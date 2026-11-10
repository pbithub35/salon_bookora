import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';

final customerPortalViewModelProvider =
    NotifierProvider.autoDispose<CustomerPortalViewModel, int>(
      CustomerPortalViewModel.new,
    );

/// State = selected bottom-nav tab index.
class CustomerPortalViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) => state = index;

  Future<void> logout() => ref.read(authProvider.notifier).logout();
}
