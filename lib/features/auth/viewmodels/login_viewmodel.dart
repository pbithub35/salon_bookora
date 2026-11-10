import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'otp_args.dart';

class LoginState {
  const LoginState({this.countryCode = '+91', this.isLoading = false});

  final String countryCode;
  final bool isLoading;

  LoginState copyWith({String? countryCode, bool? isLoading}) => LoginState(
    countryCode: countryCode ?? this.countryCode,
    isLoading: isLoading ?? this.isLoading,
  );
}

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, LoginState>(
      LoginViewModel.new,
    );

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setCountryCode(String code) {
    state = state.copyWith(countryCode: code);
  }

  /// Sends the login OTP. Returns OTP args on success, `null` on failure
  /// (feedback is already shown).
  Future<OtpArgs?> requestOtp(String mobile) async {
    state = state.copyWith(isLoading: true);
    late final AppResult<Empty> result;
    try {
      result = await ref.read(authProvider.notifier).sendOtp(
            countryCode: state.countryCode,
            mobileNumber: mobile,
            purpose: AuthPurpose.login,
          );
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }

    final l10n = ref.read(l10nProvider);
    return result.when(
      success: (_) => OtpArgs(
        countryCode: state.countryCode,
        mobileNumber: mobile,
        purpose: AuthPurpose.login,
      ),
      failure: (message, code) {
        UiFeedback.failure(l10n, message, code: code);
        return null;
      },
    );
  }
}
