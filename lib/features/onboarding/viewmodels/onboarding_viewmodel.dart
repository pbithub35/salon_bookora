import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Whether onboarding was completed (persisted in prefs; read by the router).
final onboardingSeenProvider = NotifierProvider<OnboardingSeenNotifier, bool>(
  OnboardingSeenNotifier.new,
);

class OnboardingSeenNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(prefsStorageProvider).hasSeenOnboarding;

  Future<void> markSeen() async {
    state = true;
    await ref.read(prefsStorageProvider).setHasSeenOnboarding(true);
  }
}

class OnboardingState {
  const OnboardingState({this.currentPage = 0, this.totalPages = 3});

  final int currentPage;
  final int totalPages;

  bool get isLast => currentPage >= totalPages - 1;
}

final onboardingViewModelProvider =
    NotifierProvider.autoDispose<OnboardingViewModel, OnboardingState>(
      OnboardingViewModel.new,
    );

class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void onPageChanged(int index) {
    state = OnboardingState(currentPage: index, totalPages: state.totalPages);
  }

  Future<void> completeOnboarding() =>
      ref.read(onboardingSeenProvider.notifier).markSeen();
}
