import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart' show sharedPreferencesProvider;
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../auth/viewmodels/auth_notifier.dart';

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final auth = ref.watch(authProvider);
  final user = auth.user;
  final repo = InMemoryShopRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    storageKey: 'shops_${user?.id ?? 'anonymous'}',
  );
  if (user != null) {
    repo.seedDemoShops(owner: user);
  }
  return repo;
});

final shopsProvider =
    NotifierProvider.autoDispose<ShopsViewModel, List<ShopModel>>(
      ShopsViewModel.new,
    );

class ShopsViewModel extends Notifier<List<ShopModel>> {
  ShopRepository get _repo => ref.read(shopRepositoryProvider);

  @override
  List<ShopModel> build() {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user != null) {
      _repo.seedDemoShops(owner: user);
    }
    return _repo.getShops();
  }

  void refresh() => state = _repo.getShops();

  ShopModel createShop({
    required String salonName,
    required String salonType,
    required String contactNumber,
    required String addressLine1,
    required String city,
    required String stateName,
    required String pincode,
    required List<ShopDayHours> hours,
    String? addressLine2,
    String? email,
    String? description,
    String? website,
    String? socialLinks,
    String? gstin,
    double? latitude,
    double? longitude,
    bool logoSelected = false,
    bool coverSelected = false,
  }) {
    final owner = ref.read(authProvider).user!;
    final id = 'shop_${DateTime.now().millisecondsSinceEpoch}';
    final slug = salonName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final shop = ShopModel(
      id: id,
      salonName: salonName,
      salonType: salonType,
      contactNumber: contactNumber,
      email: email,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: stateName,
      pincode: pincode,
      description: description,
      website: website,
      socialLinks: socialLinks,
      gstin: gstin,
      latitude: latitude,
      longitude: longitude,
      logoSelected: logoSelected,
      coverSelected: coverSelected,
      setupStatus: ShopSetupStatus.setupInProgress,
      bookingSlug: slug.isEmpty ? id : slug,
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
      services: const [],
      hours: hours,
    );

    _repo.addShop(shop);
    refresh();
    return shop;
  }

  ShopModel? shopById(String id) => _repo.getById(id);

  void upsert(ShopModel shop) {
    _repo.updateShop(shop);
    refresh();
  }

  bool addMember(String shopId, ShopMember member) {
    final shop = _repo.getById(shopId);
    if (shop == null ||
        shop.members.any((m) => m.mobileNumber == member.mobileNumber)) {
      return false;
    }
    upsert(shop.copyWith(members: [...shop.members, member]));
    return true;
  }

  bool removeMember(String shopId, String memberId) {
    final shop = _repo.getById(shopId);
    if (shop == null) return false;
    final member = shop.members.where((m) => m.id == memberId).firstOrNull;
    if (member == null) return false;
    if (member.role == ShopMemberRole.owner) return false;
    upsert(
      shop.copyWith(
        members: shop.members.where((m) => m.id != memberId).toList(),
      ),
    );
    return true;
  }

  bool updateMember(String shopId, ShopMember member) {
    final shop = _repo.getById(shopId);
    if (shop == null ||
        shop.members.any(
          (m) => m.id != member.id && m.mobileNumber == member.mobileNumber,
        )) {
      return false;
    }
    upsert(
      shop.copyWith(
        members: [
          for (final m in shop.members)
            if (m.id == member.id) member else m,
        ],
      ),
    );
    return true;
  }
}
