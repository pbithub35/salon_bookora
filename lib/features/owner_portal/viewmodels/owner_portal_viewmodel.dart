import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';

final ownerPortalViewModelProvider =
    NotifierProvider.autoDispose<OwnerPortalViewModel, int>(
      OwnerPortalViewModel.new,
    );

/// State = selected bottom-nav tab index.
class OwnerPortalViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) => state = index;

  Future<void> logout() => ref.read(authProvider.notifier).logout();
}
