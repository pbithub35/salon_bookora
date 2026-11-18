import 'package:flutter_test/flutter_test.dart';
import 'package:salon_bookora/core/utils/auth_destination.dart';
import 'package:salon_bookora/data/models/user_model.dart';
import 'package:salon_bookora/core/constants/app_routes.dart';

void main() {
  group('AuthDestination.resolve', () {
    UserModel user({
      required UserRole role,
      UserStatus status = UserStatus.active,
    }) {
      return UserModel(
        id: '1',
        fullName: 'Test',
        countryCode: '+91',
        mobileNumber: '9876543210',
        role: role,
        status: status,
      );
    }

    test('returns welcome when user is null', () {
      expect(AuthDestination.resolve(), AppRoutes.welcome);
    });

    test('routes suspended users to restricted', () {
      expect(
        AuthDestination.resolve(
          user: user(role: UserRole.customer, status: UserStatus.suspended),
        ),
        AppRoutes.restrictedAccount,
      );
    });

    test('routes active customers to customer shell', () {
      expect(
        AuthDestination.resolve(user: user(role: UserRole.customer)),
        AppRoutes.customerShell,
      );
    });

    test('routes owners straight to owner shell (no approval gate)', () {
      // Owner accounts are business accounts — shops are created from the
      // dashboard, so there is no pending/rejected routing anymore.
      expect(
        AuthDestination.resolve(user: user(role: UserRole.salonOwner)),
        AppRoutes.ownerShell,
      );
    });
  });
}
