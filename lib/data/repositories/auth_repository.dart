import '../models/business_model.dart';
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

  /// Creates an owner business account only — no shop is created.
  /// Shops are added later from the owner dashboard.
  Future<AppResult<AuthSessionData>> registerSalonOwner({
    required String ownerFullName,
    required String countryCode,
    required String ownerMobile,
    String? ownerEmail,
    String? brandName,
  });
}

/// Authenticated session payload returned by the repository.
class AuthSessionData {
  const AuthSessionData({
    required this.user,
    this.business,
    required this.token,
    this.refreshToken,
  });

  final UserModel user;
  final BusinessModel? business;
  final String token;
  final String? refreshToken;
}
