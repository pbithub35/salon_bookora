import 'dart:convert';

enum UserRole { customer, salonOwner }

enum UserStatus { active, suspended }

/// User Model for SalonBookora
class UserModel {
  final String id;
  final String fullName;
  final String countryCode;
  final String mobileNumber;
  final String? email;
  final String? city;
  final UserRole role;
  final UserStatus status;
  final String locale;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.countryCode,
    required this.mobileNumber,
    this.email,
    this.city,
    required this.role,
    this.status = UserStatus.active,
    this.locale = 'en',
    this.createdAt,
  });

  String get fullMobile => '$countryCode$mobileNumber';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'city': city,
      'role': role.name,
      'status': status.name,
      'locale': locale,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      countryCode: map['countryCode'] ?? '+91',
      mobileNumber: map['mobileNumber'] ?? '',
      email: map['email'],
      city: map['city'],
      role: map['role'] == 'salonOwner' || map['role'] == 'SALON_OWNER'
          ? UserRole.salonOwner
          : UserRole.customer,
      status: map['status'] == 'suspended' || map['status'] == 'SUSPENDED'
          ? UserStatus.suspended
          : UserStatus.active,
      locale: map['locale'] ?? 'en',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
