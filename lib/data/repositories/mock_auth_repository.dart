import '../../core/constants/app_constants.dart';
import '../../core/network/api_executor.dart';
import '../../core/network/app_error_codes.dart';
import '../../core/utils/app_result.dart';
import '../models/salon_model.dart';
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
    required String salonName,
    required String salonType,
    required String salonContact,
    required String address,
    required String city,
    required String state,
    required String pincode,
    String? salonEmail,
    String? description,
  }) {
    return _api.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: ownerFullName,
        countryCode: countryCode,
        mobileNumber: ownerMobile,
        email: ownerEmail,
        city: city,
        role: UserRole.salonOwner,
        status: UserStatus.active,
        createdAt: DateTime.now(),
      );

      final salon = SalonModel(
        id: 'sal_${DateTime.now().millisecondsSinceEpoch}',
        ownerId: user.id,
        salonName: salonName,
        salonType: salonType,
        contactNumber: salonContact,
        email: salonEmail,
        address: address,
        city: city,
        state: state,
        pincode: pincode,
        description: description,
        approvalStatus: SalonApprovalStatus.pending,
      );

      return AppSuccess(
        AuthSessionData(user: user, salon: salon, token: _newToken()),
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
        salon: SalonModel(
          id: 'sal_pending_1',
          ownerId: user.id,
          salonName: 'Glow Unisex Studio',
          salonType: 'Unisex Salon',
          contactNumber: mobile,
          address: 'SCO 42, Sector 70',
          city: 'Mohali',
          state: 'Punjab',
          pincode: '160071',
          approvalStatus: SalonApprovalStatus.pending,
        ),
        token: _newToken(),
      );
    }

    if (mobile == AppConstants.seedOwnerApprovedMobile) {
      final now = DateTime.now();
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
        salon: SalonModel(
          id: 'sal_approved_1',
          ownerId: user.id,
          salonName: 'The Royal Spa & Salon',
          salonType: 'Spa & Wellness',
          contactNumber: mobile,
          address: 'Mall Road, Civil Lines',
          city: 'Ludhiana',
          state: 'Punjab',
          pincode: '141001',
          approvalStatus: SalonApprovalStatus.approved,
          approvedAt: now,
          trialStartsAt: now,
          trialEndsAt: now.add(const Duration(days: 90)),
          trialStatus: SalonTrialStatus.active,
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
        salon: SalonModel(
          id: 'sal_rejected_1',
          ownerId: user.id,
          salonName: 'Elite Hair Studio',
          salonType: 'Hair Studio',
          contactNumber: mobile,
          address: 'Ranjit Avenue, Block B',
          city: 'Amritsar',
          state: 'Punjab',
          pincode: '143001',
          approvalStatus: SalonApprovalStatus.rejected,
          rejectionReason:
              'Uploaded address proof could not be verified with government municipal records.',
        ),
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
