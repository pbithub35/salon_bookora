import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'otp_args.dart';

class SalonOwnerRegisterState {
  const SalonOwnerRegisterState({
    this.isLoading = false,
    this.countryCode = '+91',
  });

  final bool isLoading;
  final String countryCode;

  SalonOwnerRegisterState copyWith({bool? isLoading, String? countryCode}) =>
      SalonOwnerRegisterState(
        isLoading: isLoading ?? this.isLoading,
        countryCode: countryCode ?? this.countryCode,
      );
}

final salonOwnerRegisterViewModelProvider =
    NotifierProvider.autoDispose<
      SalonOwnerRegisterViewModel,
      SalonOwnerRegisterState
    >(SalonOwnerRegisterViewModel.new);

class SalonOwnerRegisterViewModel extends Notifier<SalonOwnerRegisterState> {
  @override
  SalonOwnerRegisterState build() => const SalonOwnerRegisterState();

  void setCountryCode(String code) {
    state = state.copyWith(countryCode: code);
  }

  /// Sends the registration OTP for the owner business account.
  /// Returns OTP args on success, else `null`.
  Future<OtpArgs?> submit({
    required String ownerFullName,
    required String ownerMobile,
    required String ownerEmail,
    String? brandName,
  }) async {
    state = state.copyWith(isLoading: true);
    late final AppResult<Empty> result;
    try {
      result = await ref.read(authProvider.notifier).sendOtp(
            countryCode: state.countryCode,
            mobileNumber: ownerMobile,
            purpose: AuthPurpose.register,
          );
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }

    final l10n = ref.read(l10nProvider);
    return result.when(
      success: (_) => OtpArgs(
        countryCode: state.countryCode,
        mobileNumber: ownerMobile,
        purpose: AuthPurpose.register,
        role: UserRole.salonOwner,
        ownerFullName: ownerFullName,
        ownerEmail: ownerEmail,
        brandName:
            (brandName == null || brandName.trim().isEmpty)
                ? null
                : brandName.trim(),
      ),
      failure: (message, code) {
        UiFeedback.failure(
          l10n,
          message,
          code: code,
          fallbackTitle: l10n.unableToSendOtpTitle,
        );
        return null;
      },
    );
  }
}
