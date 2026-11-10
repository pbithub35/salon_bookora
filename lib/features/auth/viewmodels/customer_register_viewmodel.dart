import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'otp_args.dart';

class CustomerRegisterState {
  const CustomerRegisterState({
    this.countryCode = '+91',
    this.agreedToTerms = true,
    this.isLoading = false,
  });

  final String countryCode;
  final bool agreedToTerms;
  final bool isLoading;

  CustomerRegisterState copyWith({
    String? countryCode,
    bool? agreedToTerms,
    bool? isLoading,
  }) => CustomerRegisterState(
    countryCode: countryCode ?? this.countryCode,
    agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    isLoading: isLoading ?? this.isLoading,
  );
}

final customerRegisterViewModelProvider =
    NotifierProvider.autoDispose<
      CustomerRegisterViewModel,
      CustomerRegisterState
    >(CustomerRegisterViewModel.new);

class CustomerRegisterViewModel extends Notifier<CustomerRegisterState> {
  @override
  CustomerRegisterState build() => const CustomerRegisterState();

  void setCountryCode(String code) {
    state = state.copyWith(countryCode: code);
  }

  void toggleTerms(bool? value) {
    state = state.copyWith(agreedToTerms: value ?? false);
  }

  /// Sends the registration OTP. Returns OTP args on success, else `null`.
  Future<OtpArgs?> submit({
    required String fullName,
    required String mobile,
    String? email,
    String? city,
  }) async {
    final l10n = ref.read(l10nProvider);

    if (!state.agreedToTerms) {
      UiFeedback.error(l10n.termsRequiredTitle, l10n.termsRequiredMessage);
      return null;
    }

    state = state.copyWith(isLoading: true);
    late final AppResult<Empty> result;
    try {
      result = await ref.read(authProvider.notifier).sendOtp(
            countryCode: state.countryCode,
            mobileNumber: mobile,
            purpose: AuthPurpose.register,
          );
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }

    return result.when(
      success: (_) => OtpArgs(
        countryCode: state.countryCode,
        mobileNumber: mobile,
        purpose: AuthPurpose.register,
        fullName: fullName,
        email: (email == null || email.isEmpty) ? null : email,
        city: (city == null || city.isEmpty) ? null : city,
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
