import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';

final ownerPortalViewModelProvider =
    NotifierProvider.autoDispose<OwnerPortalViewModel, int>(
      OwnerPortalViewModel.new,
    );

/// Owner bottom tabs: Dashboard · Shops · Calendar · Team · Profile
class OwnerPortalTabs {
  static const dashboard = 0;
  static const shops = 1;
  static const calendar = 2;
  static const team = 3;
  static const profile = 4;
}

/// State = selected bottom-nav tab index.
class OwnerPortalViewModel extends Notifier<int> {
  @override
  int build() => OwnerPortalTabs.dashboard;

  void changeTab(int index) => state = index;

  Future<void> logout() => ref.read(authProvider.notifier).logout();
}
