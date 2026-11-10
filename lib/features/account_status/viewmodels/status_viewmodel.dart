import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/salon_model.dart';
import '../../auth/viewmodels/auth_notifier.dart';

final statusViewModelProvider =
    NotifierProvider.autoDispose<StatusViewModel, bool>(StatusViewModel.new);

/// State = `isChecking`.
class StatusViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  /// Returns `true` when the salon is approved (caller navigates to portal).
  Future<bool> checkApprovalStatus() async {
    state = true;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!ref.mounted) return false;
    state = false;

    final salon = ref.read(authProvider).salon;
    if (salon != null && salon.approvalStatus == SalonApprovalStatus.approved) {
      return true;
    }
    final l10n = ref.read(l10nProvider);
    UiFeedback.info(l10n.statusCheckedTitle, l10n.statusStillUnderReview);
    return false;
  }

  Future<void> logout() => ref.read(authProvider.notifier).logout();
}
