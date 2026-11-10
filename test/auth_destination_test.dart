import 'package:flutter_test/flutter_test.dart';
import 'package:salon_bookora/core/utils/auth_destination.dart';
import 'package:salon_bookora/data/models/salon_model.dart';
import 'package:salon_bookora/data/models/user_model.dart';
import 'package:salon_bookora/core/constants/app_routes.dart';

void main() {
  group('AuthDestination.resolve', () {
    test('returns welcome when user is null', () {
      expect(AuthDestination.resolve(), AppRoutes.welcome);
    });

    test('routes suspended users to restricted', () {
      final user = UserModel(
        id: '1',
        fullName: 'Blocked',
        countryCode: '+91',
        mobileNumber: '9876543250',
        role: UserRole.customer,
        status: UserStatus.suspended,
      );

      expect(
        AuthDestination.resolve(user: user),
        AppRoutes.restrictedAccount,
      );
    });

    test('routes active customers to customer shell', () {
      final user = UserModel(
        id: '1',
        fullName: 'Aarav',
        countryCode: '+91',
        mobileNumber: '9876543210',
        role: UserRole.customer,
        status: UserStatus.active,
      );

      expect(
        AuthDestination.resolve(user: user),
        AppRoutes.customerShell,
      );
    });

    test('routes pending owners to pending approval', () {
      final user = UserModel(
        id: '1',
        fullName: 'Simran',
        countryCode: '+91',
        mobileNumber: '9876543220',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      const salon = SalonModel(
        id: 's1',
        ownerId: '1',
        salonName: 'Glow',
        salonType: 'Unisex Salon',
        contactNumber: '9876543220',
        address: 'Sector 70',
        city: 'Mohali',
        state: 'Punjab',
        pincode: '160071',
        approvalStatus: SalonApprovalStatus.pending,
      );

      expect(
        AuthDestination.resolve(user: user, salon: salon),
        AppRoutes.pendingApproval,
      );
    });

    test('routes approved owners to owner shell', () {
      final user = UserModel(
        id: '1',
        fullName: 'Rajesh',
        countryCode: '+91',
        mobileNumber: '9876543230',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      const salon = SalonModel(
        id: 's1',
        ownerId: '1',
        salonName: 'Royal',
        salonType: 'Spa & Wellness',
        contactNumber: '9876543230',
        address: 'Mall Road',
        city: 'Ludhiana',
        state: 'Punjab',
        pincode: '141001',
        approvalStatus: SalonApprovalStatus.approved,
      );

      expect(
        AuthDestination.resolve(user: user, salon: salon),
        AppRoutes.ownerShell,
      );
    });

    test('routes rejected owners to rejected application', () {
      final user = UserModel(
        id: '1',
        fullName: 'Karan',
        countryCode: '+91',
        mobileNumber: '9876543240',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );
      const salon = SalonModel(
        id: 's1',
        ownerId: '1',
        salonName: 'Elite',
        salonType: 'Hair Studio',
        contactNumber: '9876543240',
        address: 'Block B',
        city: 'Amritsar',
        state: 'Punjab',
        pincode: '143001',
        approvalStatus: SalonApprovalStatus.rejected,
      );

      expect(
        AuthDestination.resolve(user: user, salon: salon),
        AppRoutes.rejectedApplication,
      );
    });

    test('routes owner without salon to pending approval', () {
      final user = UserModel(
        id: '1',
        fullName: 'Owner',
        countryCode: '+91',
        mobileNumber: '9000000000',
        role: UserRole.salonOwner,
        status: UserStatus.active,
      );

      expect(
        AuthDestination.resolve(user: user),
        AppRoutes.pendingApproval,
      );
    });
  });
}
