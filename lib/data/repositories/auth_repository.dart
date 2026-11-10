import '../models/salon_model.dart';
import '../models/user_model.dart';
import '../../core/utils/app_result.dart';

enum AuthPurpose { login, register }

/// Contract for authentication / registration.
/// Phase 1 ships a mock implementation; swap for a remote API later.
abstract class AuthRepository {
  Future<AppResult<Empty>> sendOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
  });

  Future<AppResult<Empty>> verifyOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
    required String otp,
  });

  /// Resolves an existing account for login after OTP success.
  Future<AppResult<AuthSessionData>> loginWithMobile({
    required String countryCode,
    required String mobileNumber,
  });

  Future<AppResult<AuthSessionData>> registerCustomer({
    required String fullName,
    required String countryCode,
    required String mobileNumber,
    String? email,
    String? city,
  });

  Future<AppResult<AuthSessionData>> registerSalonOwner({
    required String ownerFullName,
    required String countryCode,
    required String ownerMobile,
    String? ownerEmail,
    required String salonName,
    required String salonType,
    required String salonContact,
    required String address,
    required String city,
    required String state,
    required String pincode,
    String? salonEmail,
    String? description,
  });
}

/// Authenticated session payload returned by the repository.
class AuthSessionData {
  const AuthSessionData({required this.user, this.salon, required this.token});

  final UserModel user;
  final SalonModel? salon;
  final String token;
}
