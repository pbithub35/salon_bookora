import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../../onboarding/viewmodels/onboarding_viewmodel.dart';

final splashViewModelProvider =
    NotifierProvider.autoDispose<SplashViewModel, void>(SplashViewModel.new);

class SplashViewModel extends Notifier<void> {
  @override
  void build() {}

  /// Waits for the splash display time and resolves the next route.
  Future<String> resolveDestination() async {
    // 2.5 seconds splash display as specified in design doc
    await Future<void>.delayed(const Duration(milliseconds: 2500));

    final auth = ref.read(authProvider);
    if (auth.isLoggedIn) return auth.destinationRoute;
    if (!ref.read(onboardingSeenProvider)) return AppRoutes.onboarding;
    return AppRoutes.welcome;
  }
}
