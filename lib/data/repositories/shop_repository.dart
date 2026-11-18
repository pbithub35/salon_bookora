import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/shop_model.dart';
import '../models/user_model.dart';

/// Local shop store for the owner portal (swap for remote later).
abstract class ShopRepository {
  List<ShopModel> getShops();
  ShopModel? getById(String id);
  ShopModel addShop(ShopModel shop);
  ShopModel updateShop(ShopModel shop);
  void seedDemoShops({required UserModel owner});
}

class InMemoryShopRepository implements ShopRepository {
  InMemoryShopRepository({
    SharedPreferences? preferences,
    required this.storageKey,
  }) : _preferences = preferences {
    final saved = _preferences?.getString(storageKey);
    if (saved != null) {
      try {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _shops.addAll(
          decoded.map((value) => _shopFromJson(value as Map<String, dynamic>)),
        );
        _seeded = _shops.isNotEmpty;
      } on Object {
        _shops.clear();
      }
    }
  }

  final SharedPreferences? _preferences;
  final String storageKey;
  final List<ShopModel> _shops = [];
  bool _seeded = false;

  void _persist() {
    final preferences = _preferences;
    if (preferences == null) return;
    unawaited(
      preferences.setString(
        storageKey,
        jsonEncode(_shops.map(_shopToJson).toList()),
      ),
    );
  }

  @override
  List<ShopModel> getShops() => List.unmodifiable(_shops);

  @override
  ShopModel? getById(String id) {
    for (final shop in _shops) {
      if (shop.id == id) return shop;
    }
    return null;
  }

  @override
  ShopModel addShop(ShopModel shop) {
    _shops.insert(0, shop);
    _persist();
    return shop;
  }

  @override
  ShopModel updateShop(ShopModel shop) {
    final index = _shops.indexWhere((s) => s.id == shop.id);
    if (index >= 0) {
      _shops[index] = shop;
    } else {
      _shops.add(shop);
    }
    _persist();
    return shop;
  }

  @override
  void seedDemoShops({required UserModel owner}) {
    if (_seeded) return;
    _seeded = true;

    ShopModel shop({
      required String id,
      required String name,
      required String city,
      required String state,
      required String pincode,
      required String address,
      ShopSetupStatus status = ShopSetupStatus.setupInProgress,
    }) {
      return ShopModel(
        id: id,
        salonName: name,
        salonType: 'Salon',
        contactNumber: owner.mobileNumber,
        email: owner.email,
        addressLine1: address,
        city: city,
        state: state,
        pincode: pincode,
        bookingSlug: name
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
            .replaceAll(RegExp(r'^-|-$'), ''),
        setupStatus: status,
        members: [
          ShopMember(
            id: owner.id,
            name: owner.fullName,
            mobileNumber: owner.mobileNumber,
            email: owner.email,
            role: ShopMemberRole.owner,
            permissions: ShopPermissions.forRole(ShopMemberRole.owner),
          ),
        ],
        services: const [
          ShopServiceItem(
            id: 'svc_1',
            name: 'Haircut & Styling',
            category: 'Hair',
            durationMinutes: 45,
            price: 499,
          ),
          ShopServiceItem(
            id: 'svc_2',
            name: 'Beard Trim',
            category: 'Grooming',
            durationMinutes: 20,
            price: 199,
          ),
        ],
        hours: defaultHours(),
      );
    }

    // Demo shops for the Phase 1 seed owners (mirrors backend seed.ts).
    // New owners get an empty workspace and create their first shop.
    switch (owner.mobileNumber) {
      case '9876543220':
        _shops.add(
          shop(
            id: 'shop_seed_3220',
            name: 'Glow Unisex Studio, Mohali',
            city: 'Mohali',
            state: 'Punjab',
            pincode: '160071',
            address: 'SCO 42, Sector 70',
            status: ShopSetupStatus.ready,
          ),
        );
      case '9876543230':
        _shops.addAll([
          shop(
            id: 'shop_seed_3230_a',
            name: 'The Royal Spa, Ludhiana',
            city: 'Ludhiana',
            state: 'Punjab',
            pincode: '141001',
            address: 'Mall Road, Civil Lines',
            status: ShopSetupStatus.ready,
          ),
          shop(
            id: 'shop_seed_3230_b',
            name: 'The Royal Spa, Delhi',
            city: 'Delhi',
            state: 'Delhi',
            pincode: '110001',
            address: '12 Rajpath, Connaught Place',
          ),
        ]);
    }
    _persist();
  }

  static List<ShopDayHours> defaultHours() {
    return List.generate(7, (i) {
      final day = i + 1;
      return ShopDayHours(
        dayIndex: day,
        open: '10:00',
        close: '20:00',
        isClosed: day == 7,
      );
    });
  }

  static Map<String, dynamic> _shopToJson(ShopModel shop) => {
    'id': shop.id,
    'salonName': shop.salonName,
    'salonType': shop.salonType,
    'contactNumber': shop.contactNumber,
    'addressLine1': shop.addressLine1,
    'addressLine2': shop.addressLine2,
    'city': shop.city,
    'state': shop.state,
    'pincode': shop.pincode,
    'email': shop.email,
    'description': shop.description,
    'website': shop.website,
    'socialLinks': shop.socialLinks,
    'gstin': shop.gstin,
    'latitude': shop.latitude,
    'longitude': shop.longitude,
    'logoSelected': shop.logoSelected,
    'coverSelected': shop.coverSelected,
    'bookingSlug': shop.bookingSlug,
    'setupStatus': shop.setupStatus.name,
    'members': shop.members
        .map(
          (member) => {
            'id': member.id,
            'name': member.name,
            'mobileNumber': member.mobileNumber,
            'email': member.email,
            'role': member.role.name,
            'serviceIds': member.serviceIds,
            'permissions': {
              'manageBookings': member.permissions.manageBookings,
              'manageServices': member.permissions.manageServices,
              'manageStaff': member.permissions.manageStaff,
              'manageShopSettings': member.permissions.manageShopSettings,
            },
          },
        )
        .toList(),
    'services': shop.services
        .map(
          (service) => {
            'id': service.id,
            'name': service.name,
            'category': service.category,
            'durationMinutes': service.durationMinutes,
            'price': service.price,
          },
        )
        .toList(),
    'hours': shop.hours
        .map(
          (hours) => {
            'dayIndex': hours.dayIndex,
            'open': hours.open,
            'close': hours.close,
            'isClosed': hours.isClosed,
          },
        )
        .toList(),
  };

  static ShopModel _shopFromJson(Map<String, dynamic> json) {
    final members = (json['members'] as List<dynamic>? ?? []).map((item) {
      final value = item as Map<String, dynamic>;
      final permissions = value['permissions'] as Map<String, dynamic>? ?? {};
      return ShopMember(
        id: value['id'] as String,
        name: value['name'] as String,
        mobileNumber: value['mobileNumber'] as String,
        email: value['email'] as String?,
        role: ShopMemberRole.values.byName(value['role'] as String),
        serviceIds: (value['serviceIds'] as List<dynamic>? ?? [])
            .whereType<String>()
            .toList(),
        permissions: ShopPermissions(
          manageBookings: permissions['manageBookings'] as bool? ?? false,
          manageServices: permissions['manageServices'] as bool? ?? false,
          manageStaff: permissions['manageStaff'] as bool? ?? false,
          manageShopSettings:
              permissions['manageShopSettings'] as bool? ?? false,
        ),
      );
    }).toList();
    final services = (json['services'] as List<dynamic>? ?? []).map((item) {
      final value = item as Map<String, dynamic>;
      return ShopServiceItem(
        id: value['id'] as String,
        name: value['name'] as String,
        category: value['category'] as String?,
        durationMinutes: (value['durationMinutes'] as num).toInt(),
        price: (value['price'] as num).toDouble(),
      );
    }).toList();
    final hours = (json['hours'] as List<dynamic>? ?? []).map((item) {
      final value = item as Map<String, dynamic>;
      return ShopDayHours(
        dayIndex: (value['dayIndex'] as num).toInt(),
        open: value['open'] as String,
        close: value['close'] as String,
        isClosed: value['isClosed'] as bool? ?? false,
      );
    }).toList();
    return ShopModel(
      id: json['id'] as String,
      salonName: json['salonName'] as String,
      salonType: json['salonType'] as String,
      contactNumber: json['contactNumber'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      email: json['email'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      socialLinks: json['socialLinks'] as String?,
      gstin: json['gstin'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      logoSelected: json['logoSelected'] as bool? ?? false,
      coverSelected: json['coverSelected'] as bool? ?? false,
      bookingSlug: json['bookingSlug'] as String?,
      setupStatus: ShopSetupStatus.values.byName(json['setupStatus'] as String),
      members: members,
      services: services,
      hours: hours,
    );
  }
}
