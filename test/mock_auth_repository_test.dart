import 'package:flutter_test/flutter_test.dart';
import 'package:salon_bookora/core/constants/app_constants.dart';
import 'package:salon_bookora/core/network/api_executor.dart';
import 'package:salon_bookora/core/network/app_error_codes.dart';
import 'package:salon_bookora/core/network/network_info.dart';
import 'package:salon_bookora/data/models/salon_model.dart';
import 'package:salon_bookora/data/models/user_model.dart';
import 'package:salon_bookora/data/repositories/auth_repository.dart';
import 'package:salon_bookora/data/repositories/mock_auth_repository.dart';

void main() {
  late FakeNetworkInfo networkInfo;
  late MockAuthRepository repository;

  setUp(() {
    networkInfo = FakeNetworkInfo(connected: true);
    repository = MockAuthRepository(
      apiExecutor: ApiExecutor(networkInfo: networkInfo),
    );
  });

  group('MockAuthRepository', () {
    test('login sendOtp fails for unknown numbers', () async {
      final result = await repository.sendOtp(
        countryCode: '+91',
        mobileNumber: '1111111111',
        purpose: AuthPurpose.login,
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, contains('No account found'));
      expect(result.codeOrNull, AppErrorCodes.accountNotFound);
    });

    test('blocks call when offline', () async {
      networkInfo.connected = false;

      final result = await repository.sendOtp(
        countryCode: '+91',
        mobileNumber: AppConstants.seedCustomerMobile,
        purpose: AuthPurpose.login,
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, AppErrorMessages.noInternet);
      expect(result.codeOrNull, AppErrorCodes.noInternet);
    });

    test('login sendOtp succeeds for seed customer', () async {
      final result = await repository.sendOtp(
        countryCode: '+91',
        mobileNumber: AppConstants.seedCustomerMobile,
        purpose: AuthPurpose.login,
      );

      expect(result.isSuccess, isTrue);
    });

    test('verifyOtp rejects non-dev OTP', () async {
      final result = await repository.verifyOtp(
        countryCode: '+91',
        mobileNumber: AppConstants.seedCustomerMobile,
        purpose: AuthPurpose.login,
        otp: '1234',
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, contains('correct 4-digit OTP'));
    });

    test('verifyOtp accepts dev OTP', () async {
      final result = await repository.verifyOtp(
        countryCode: '+91',
        mobileNumber: AppConstants.seedCustomerMobile,
        purpose: AuthPurpose.login,
        otp: AppConstants.devOtp,
      );

      expect(result.isSuccess, isTrue);
    });

    test('loginWithMobile returns approved owner with trial', () async {
      final result = await repository.loginWithMobile(
        countryCode: '+91',
        mobileNumber: AppConstants.seedOwnerApprovedMobile,
      );

      expect(result.isSuccess, isTrue);
      final session = result.dataOrNull!;
      expect(session.user.role, UserRole.salonOwner);
      expect(session.salon?.approvalStatus, SalonApprovalStatus.approved);
      expect(session.salon?.trialStatus, SalonTrialStatus.active);
      expect(session.token, isNotEmpty);
    });

    test('registerCustomer creates active customer session', () async {
      final result = await repository.registerCustomer(
        fullName: 'Test User',
        countryCode: '+91',
        mobileNumber: '9000011111',
        email: 'test@example.com',
        city: 'Mohali',
      );

      expect(result.isSuccess, isTrue);
      final session = result.dataOrNull!;
      expect(session.user.fullName, 'Test User');
      expect(session.user.role, UserRole.customer);
      expect(session.user.status, UserStatus.active);
      expect(session.salon, isNull);
    });

    test('registerSalonOwner starts as pending approval', () async {
      final result = await repository.registerSalonOwner(
        ownerFullName: 'Owner',
        countryCode: '+91',
        ownerMobile: '9000022222',
        salonName: 'New Salon',
        salonType: 'Unisex Salon',
        salonContact: '9000022222',
        address: 'SCO 1',
        city: 'Mohali',
        state: 'Punjab',
        pincode: '160071',
      );

      expect(result.isSuccess, isTrue);
      final session = result.dataOrNull!;
      expect(session.user.role, UserRole.salonOwner);
      expect(session.salon?.approvalStatus, SalonApprovalStatus.pending);
    });
  });
}
