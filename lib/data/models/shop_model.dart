enum ShopMemberRole { owner, subAdmin, staff }

enum ShopSetupStatus { setupInProgress, ready }

class ShopPermissions {
  const ShopPermissions({
    this.manageBookings = false,
    this.manageServices = false,
    this.manageStaff = false,
    this.manageShopSettings = false,
  });

  final bool manageBookings;
  final bool manageServices;
  final bool manageStaff;
  final bool manageShopSettings;

  factory ShopPermissions.forRole(ShopMemberRole role) {
    return switch (role) {
      ShopMemberRole.owner => const ShopPermissions(
        manageBookings: true,
        manageServices: true,
        manageStaff: true,
        manageShopSettings: true,
      ),
      ShopMemberRole.subAdmin => const ShopPermissions(
        manageBookings: true,
        manageServices: true,
        manageStaff: true,
        manageShopSettings: true,
      ),
      ShopMemberRole.staff => const ShopPermissions(manageBookings: true),
    };
  }

  ShopPermissions copyWith({
    bool? manageBookings,
    bool? manageServices,
    bool? manageStaff,
    bool? manageShopSettings,
  }) {
    return ShopPermissions(
      manageBookings: manageBookings ?? this.manageBookings,
      manageServices: manageServices ?? this.manageServices,
      manageStaff: manageStaff ?? this.manageStaff,
      manageShopSettings: manageShopSettings ?? this.manageShopSettings,
    );
  }
}

class ShopMember {
  const ShopMember({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.role,
    required this.permissions,
    this.email,
    this.serviceIds = const [],
  });

  final String id;
  final String name;
  final String mobileNumber;
  final String? email;
  final ShopMemberRole role;
  final ShopPermissions permissions;

  /// Services this staff member can perform at this shop.
  final List<String> serviceIds;

  ShopMember copyWith({
    String? name,
    String? mobileNumber,
    String? email,
    ShopMemberRole? role,
    ShopPermissions? permissions,
    List<String>? serviceIds,
  }) {
    return ShopMember(
      id: id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      serviceIds: serviceIds ?? this.serviceIds,
    );
  }
}

class ShopServiceItem {
  const ShopServiceItem({
    required this.id,
    required this.name,
    this.category,
    required this.durationMinutes,
    required this.price,
  });

  final String id;
  final String name;
  final String? category;
  final int durationMinutes;
  final double price;
}

class ShopDayHours {
  const ShopDayHours({
    required this.dayIndex,
    required this.open,
    required this.close,
    this.isClosed = false,
  });

  /// 1 = Monday … 7 = Sunday
  final int dayIndex;
  final String open;
  final String close;
  final bool isClosed;

  ShopDayHours copyWith({String? open, String? close, bool? isClosed}) {
    return ShopDayHours(
      dayIndex: dayIndex,
      open: open ?? this.open,
      close: close ?? this.close,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

class ShopModel {
  const ShopModel({
    required this.id,
    required this.salonName,
    required this.salonType,
    required this.contactNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.members,
    required this.services,
    required this.hours,
    this.setupStatus = ShopSetupStatus.setupInProgress,
    this.addressLine2,
    this.email,
    this.description,
    this.website,
    this.socialLinks,
    this.gstin,
    this.latitude,
    this.longitude,
    this.logoSelected = false,
    this.coverSelected = false,
    this.bookingSlug,
  });

  final String id;
  final String salonName;
  final String salonType;
  final String contactNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? email;
  final String? description;
  final String? website;
  final String? socialLinks;
  final String? gstin;
  final double? latitude;
  final double? longitude;
  final bool logoSelected;
  final bool coverSelected;
  final String? bookingSlug;
  final ShopSetupStatus setupStatus;
  final List<ShopMember> members;
  final List<ShopServiceItem> services;
  final List<ShopDayHours> hours;

  String get address => [
    addressLine1,
    if (addressLine2 != null && addressLine2!.trim().isNotEmpty) addressLine2,
  ].join(', ');

  int get setupCompletedSteps {
    var done = 1; // details+location+hours saved
    if (services.isNotEmpty) done++;
    if (members.any((member) => member.role == ShopMemberRole.staff)) done++;
    return done;
  }

  int get setupTotalSteps => 3;

  double get setupProgress => setupCompletedSteps / setupTotalSteps;

  ShopModel copyWith({
    String? salonName,
    String? salonType,
    String? contactNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? email,
    String? description,
    String? website,
    String? socialLinks,
    String? gstin,
    double? latitude,
    double? longitude,
    bool? logoSelected,
    bool? coverSelected,
    String? bookingSlug,
    ShopSetupStatus? setupStatus,
    List<ShopMember>? members,
    List<ShopServiceItem>? services,
    List<ShopDayHours>? hours,
  }) {
    final nextServices = services ?? this.services;
    final nextMembers = members ?? this.members;
    final hasStaff = nextMembers.any(
      (member) => member.role == ShopMemberRole.staff,
    );
    final nextSetupStatus =
        setupStatus ??
        (nextServices.isNotEmpty && hasStaff
            ? ShopSetupStatus.ready
            : ShopSetupStatus.setupInProgress);
    return ShopModel(
      id: id,
      salonName: salonName ?? this.salonName,
      salonType: salonType ?? this.salonType,
      contactNumber: contactNumber ?? this.contactNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      email: email ?? this.email,
      description: description ?? this.description,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
      gstin: gstin ?? this.gstin,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      logoSelected: logoSelected ?? this.logoSelected,
      coverSelected: coverSelected ?? this.coverSelected,
      bookingSlug: bookingSlug ?? this.bookingSlug,
      setupStatus: nextSetupStatus,
      members: nextMembers,
      services: nextServices,
      hours: hours ?? this.hours,
    );
  }
}
