import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../features/account_status/views/pending_approval_view.dart';
import '../features/account_status/views/rejected_application_view.dart';
import '../features/account_status/views/restricted_account_view.dart';
import '../features/auth/viewmodels/auth_notifier.dart';
import '../features/auth/viewmodels/otp_args.dart';
import '../features/auth/views/customer_register_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/otp_verification_view.dart';
import '../features/auth/views/registration_success_view.dart';
import '../features/auth/views/role_selection_view.dart';
import '../features/auth/views/salon_owner_register_view.dart';
import '../features/auth/views/welcome_view.dart';
import '../features/customer_portal/views/customer_shell_view.dart';
import '../features/onboarding/viewmodels/onboarding_viewmodel.dart';
import '../features/onboarding/views/onboarding_view.dart';
import '../features/owner_portal/views/owner_shell_view.dart';
import '../features/splash/views/splash_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Routes only reachable with a session; status/shell routes must also match
/// the user's [AuthState.destinationRoute].
const _destinationRoutes = {
  AppRoutes.customerShell,
  AppRoutes.ownerShell,
  AppRoutes.pendingApproval,
  AppRoutes.rejectedApplication,
  AppRoutes.restrictedAccount,
};

/// Public entry routes a logged-in user is bounced away from.
const _entryRoutes = {
  AppRoutes.onboarding,
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.roleSelect,
};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => refresh.value++);
  ref.listen(onboardingSeenProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final path = state.uri.path;

      if (path == AppRoutes.splash) return null;

      if (!auth.isLoggedIn) {
        final needsSession =
            _destinationRoutes.contains(path) ||
            path == AppRoutes.registrationSuccess;
        return needsSession ? AppRoutes.welcome : null;
      }

      if (_entryRoutes.contains(path)) return auth.destinationRoute;
      if (_destinationRoutes.contains(path) && path != auth.destinationRoute) {
        return auth.destinationRoute;
      }
      return null;
    },
    routes: [
      _route(AppRoutes.splash, (_) => const SplashView(), fade: true),
      _route(AppRoutes.onboarding, (_) => const OnboardingView()),
      _route(AppRoutes.welcome, (_) => const WelcomeView(), fade: true),
      _route(AppRoutes.login, (_) => const LoginView()),
      _route(AppRoutes.roleSelect, (_) => const RoleSelectionView()),
      _route(AppRoutes.registerCustomer, (_) => const CustomerRegisterView()),
      _route(AppRoutes.registerOwner, (_) => const SalonOwnerRegisterView()),
      _route(
        AppRoutes.otp,
        (state) => OtpVerificationView(args: state.extra! as OtpArgs),
        redirect: (_, state) =>
            state.extra is OtpArgs ? null : AppRoutes.welcome,
      ),
      _route(
        AppRoutes.registrationSuccess,
        (state) => RegistrationSuccessView(
          isCustomer: state.uri.queryParameters['role'] != 'SALON_OWNER',
        ),
        fade: true,
      ),
      _route(
        AppRoutes.pendingApproval,
        (_) => const PendingApprovalView(),
        fade: true,
      ),
      _route(
        AppRoutes.rejectedApplication,
        (_) => const RejectedApplicationView(),
        fade: true,
      ),
      _route(
        AppRoutes.restrictedAccount,
        (_) => const RestrictedAccountView(),
        fade: true,
      ),
      _route(
        AppRoutes.customerShell,
        (_) => const CustomerShellView(),
        fade: true,
      ),
      _route(AppRoutes.ownerShell, (_) => const OwnerShellView(), fade: true),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

GoRoute _route(
  String path,
  Widget Function(GoRouterState state) builder, {
  bool fade = false,
  GoRouterRedirect? redirect,
}) {
  return GoRoute(
    path: path,
    redirect: redirect,
    pageBuilder: (context, state) => fade
        ? CustomTransitionPage<void>(
            key: state.pageKey,
            child: builder(state),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
          )
        : MaterialPage<void>(key: state.pageKey, child: builder(state)),
  );
}
