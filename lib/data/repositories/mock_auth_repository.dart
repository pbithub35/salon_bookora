import '../../core/constants/app_constants.dart';
import '../../core/network/api_executor.dart';
import '../../core/network/app_error_codes.dart';
import '../../core/utils/app_result.dart';
import '../models/business_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Local/dev auth implementation using Phase 1 seed accounts.
/// Every method still goes through [ApiExecutor] (internet + common errors).
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({required ApiExecutor apiExecutor}) : _api = apiExecutor;

  final ApiExecutor _api;

  @override
  Future<AppResult<Empty>> sendOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 700));

      if (purpose == AuthPurpose.login && !_isKnownUser(mobileNumber)) {
        return const AppFailure(
          'No account found with this number. Please register first.',
          code: AppErrorCodes.accountNotFound,
        );
      }

      return const AppSuccess(empty);
    });
  }

  @override
  Future<AppResult<Empty>> verifyOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
    required String otp,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (otp != AppConstants.devOtp) {
        return AppFailure(
          'Please enter correct 4-digit OTP (${AppConstants.devOtp} in Dev Mode)',
          code: AppErrorCodes.invalidOtp,
        );
      }

      return const AppSuccess(empty);
    });
  }

  @override
  Future<AppResult<AuthSessionData>> loginWithMobile({
    required String countryCode,
    required String mobileNumber,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return AppSuccess(_sessionForMobile(mobileNumber, countryCode));
    });
  }

  @override
  Future<AppResult<AuthSessionData>> registerCustomer({
    required String fullName,
    required String countryCode,
    required String mobileNumber,
    String? email,
    String? city,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName,
        countryCode: countryCode,
        mobileNumber: mobileNumber,
        email: email,
        city: city,
        role: UserRole.customer,
        status: UserStatus.active,
        createdAt: DateTime.now(),
      );

      return AppSuccess(AuthSessionData(user: user, token: _newToken()));
    });
  }

  @override
  Future<AppResult<AuthSessionData>> registerSalonOwner({
    required String ownerFullName,
    required String countryCode,
    required String ownerMobile,
    String? ownerEmail,
    String? brandName,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: ownerFullName,
        countryCode: countryCode,
        mobileNumber: ownerMobile,
        email: ownerEmail,
        role: UserRole.salonOwner,
        status: UserStatus.active,
        createdAt: DateTime.now(),
      );

      // Business account only — shops are created later from the dashboard.
      final business = BusinessModel(
        id: 'biz_${DateTime.now().millisecondsSinceEpoch}',
        ownerId: user.id,
        brandName:
            (brandName == null || brandName.trim().isEmpty)
                ? null
                : brandName.trim(),
      );

      return AppSuccess(
        AuthSessionData(user: user, business: business, token: _newToken()),
      );
    });
  }

  bool _isKnownUser(String mobile) {
    return const [
      AppConstants.seedCustomerMobile,
      AppConstants.seedOwnerPendingMobile,
      AppConstants.seedOwnerApprovedMobile,
      AppConstants.seedOwnerRejectedMobile,
      AppConstants.seedSuspendedMobile,
    ].contains(mobile);
  }

  AuthSessionData _sessionForMobile(String mobile, String countryCode) {
    if (mobile == AppConstants.seedCustomerMobile) {
      return AuthSessionData(
        user: UserModel(
          id: 'usr_cust_1',
          fullName: 'Aarav Sharma',
          countryCode: countryCode,
          mobileNumber: mobile,
          city: 'Mohali',
          role: UserRole.customer,
          status: UserStatus.active,
        ),
        token: _newToken(),
      );
    }

    if (mobile == AppConstants.seedOwnerPendingMobile) {
      final user = UserModel(
        id: 'usr_owner_pending',
        fullName: 'Simran Kaur',
        countryCode: countryCode,
        mobileNumber: mobile,
        city: 'Chandigarh',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      return AuthSessionData(
        user: user,
        business: BusinessModel(
          id: 'biz_owner_pending',
          ownerId: user.id,
          brandName: 'Glow Unisex Studio',
        ),
        token: _newToken(),
      );
    }

    if (mobile == AppConstants.seedOwnerApprovedMobile) {
      final user = UserModel(
        id: 'usr_owner_approved',
        fullName: 'Rajesh Verma',
        countryCode: countryCode,
        mobileNumber: mobile,
        city: 'Ludhiana',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      return AuthSessionData(
        user: user,
        business: BusinessModel(
          id: 'biz_owner_approved',
          ownerId: user.id,
          brandName: 'The Royal Spa',
        ),
        token: _newToken(),
      );
    }

    if (mobile == AppConstants.seedOwnerRejectedMobile) {
      final user = UserModel(
        id: 'usr_owner_rejected',
        fullName: 'Karan Mehra',
        countryCode: countryCode,
        mobileNumber: mobile,
        city: 'Amritsar',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      return AuthSessionData(
        user: user,
        business: BusinessModel(id: 'biz_owner_rejected', ownerId: user.id),
        token: _newToken(),
      );
    }

    if (mobile == AppConstants.seedSuspendedMobile) {
      return AuthSessionData(
        user: UserModel(
          id: 'usr_suspended_1',
          fullName: 'Suspended Account User',
          countryCode: countryCode,
          mobileNumber: mobile,
          city: 'Delhi',
          role: UserRole.customer,
          status: UserStatus.suspended,
        ),
        token: _newToken(),
      );
    }

    return AuthSessionData(
      user: UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: 'Salon Client',
        countryCode: countryCode,
        mobileNumber: mobile,
        role: UserRole.customer,
        status: UserStatus.active,
      ),
      token: _newToken(),
    );
  }

  String _newToken() => 'token_${DateTime.now().millisecondsSinceEpoch}';
}
