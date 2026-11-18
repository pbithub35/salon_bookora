import '../../data/models/user_model.dart';
import '../constants/app_routes.dart';

/// Pure routing rules for post-auth navigation.
/// Keep this free of UI/framework deps so it stays unit-testable.
class AuthDestination {
  AuthDestination._();

  static String resolve({UserModel? user}) {
    if (user == null) return AppRoutes.welcome;

    if (user.status == UserStatus.suspended) {
      return AppRoutes.restrictedAccount;
    }

    // Owner accounts land directly on the dashboard — shops are created
    // from there ("Create your first shop"), not during registration.
    if (user.role == UserRole.salonOwner) {
      return AppRoutes.ownerShell;
    }

    return AppRoutes.customerShell;
  }
}
