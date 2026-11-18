import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// Typed navigation payload for the OTP screen (passed via GoRouter `extra`).
/// Carries the registration draft so the final step can submit it.
class OtpArgs {
  const OtpArgs({
    this.countryCode = '+91',
    this.mobileNumber = '',
    this.purpose = AuthPurpose.login,
    this.role = UserRole.customer,
    this.fullName,
    this.email,
    this.city,
    this.ownerFullName,
    this.ownerEmail,
    this.brandName,
  });

  final String countryCode;
  final String mobileNumber;
  final AuthPurpose purpose;
  final UserRole role;

  // Customer registration
  final String? fullName;
  final String? email;
  final String? city;

  // Salon owner (business account) registration
  final String? ownerFullName;
  final String? ownerEmail;
  final String? brandName;
}
