import '../../data/models/salon_model.dart';
import '../../data/models/user_model.dart';
import '../constants/app_routes.dart';

/// Pure routing rules for post-auth navigation.
/// Keep this free of UI/framework deps so it stays unit-testable.
class AuthDestination {
  AuthDestination._();

  static String resolve({UserModel? user, SalonModel? salon}) {
    if (user == null) return AppRoutes.welcome;

    if (user.status == UserStatus.suspended) {
      return AppRoutes.restrictedAccount;
    }

    if (user.role == UserRole.customer) {
      return AppRoutes.customerShell;
    }

    // Salon owner flow is gated by salon approval status.
    if (salon == null || salon.approvalStatus == SalonApprovalStatus.pending) {
      return AppRoutes.pendingApproval;
    }

    if (salon.approvalStatus == SalonApprovalStatus.rejected) {
      return AppRoutes.rejectedApplication;
    }

    if (salon.approvalStatus == SalonApprovalStatus.approved) {
      return AppRoutes.ownerShell;
    }

    return AppRoutes.pendingApproval;
  }
}
