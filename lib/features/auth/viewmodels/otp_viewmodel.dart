import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'otp_args.dart';

class OtpState {
  const OtpState({
    this.enteredOtp = '',
    this.isLoading = false,
    this.hasError = false,
    this.resendTimer = 60,
    this.canResend = false,
  });

  final String enteredOtp;
  final bool isLoading;
  final bool hasError;
  final int resendTimer;
  final bool canResend;

  OtpState copyWith({
    String? enteredOtp,
    bool? isLoading,
    bool? hasError,
    int? resendTimer,
    bool? canResend,
  }) => OtpState(
    enteredOtp: enteredOtp ?? this.enteredOtp,
    isLoading: isLoading ?? this.isLoading,
    hasError: hasError ?? this.hasError,
    resendTimer: resendTimer ?? this.resendTimer,
    canResend: canResend ?? this.canResend,
  );
}

final otpViewModelProvider = NotifierProvider.autoDispose
    .family<OtpViewModel, OtpState, OtpArgs>(OtpViewModel.new);

class OtpViewModel extends Notifier<OtpState> {
  OtpViewModel(this.args);

  final OtpArgs args;
  Timer? _countdownTimer;

  @override
  OtpState build() {
    ref.onDispose(() => _countdownTimer?.cancel());
    _startTimer();
    return const OtpState();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!ref.mounted) {
        timer.cancel();
        return;
      }
      if (state.resendTimer > 0) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      }
      if (state.resendTimer <= 0) {
        state = state.copyWith(canResend: true);
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String otp) {
    state = state.copyWith(enteredOtp: otp, hasError: false);
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;

    final l10n = ref.read(l10nProvider);
    final result = await ref
        .read(authProvider.notifier)
        .sendOtp(
          countryCode: args.countryCode,
          mobileNumber: args.mobileNumber,
          purpose: args.purpose,
        );
    if (!ref.mounted) return;

    result.when(
      success: (_) {
        UiFeedback.info(l10n.otpSentTitle, l10n.otpResentMessage);
        state = state.copyWith(resendTimer: 60, canResend: false);
        _startTimer();
      },
      failure: (message, code) {
        UiFeedback.failure(
          l10n,
          message,
          code: code,
          fallbackTitle: l10n.unableToResendOtpTitle,
        );
      },
    );
  }

  /// Verifies the OTP. Returns the route to navigate to on success, else
  /// `null` (feedback is already shown).
  Future<String?> verify() async {
    final l10n = ref.read(l10nProvider);

    if (state.enteredOtp.length != 4) {
      state = state.copyWith(hasError: true);
      UiFeedback.error(l10n.incompleteCodeTitle, l10n.incompleteCodeMessage);
      return null;
    }

    state = state.copyWith(isLoading: true);
    late final AppResult<Empty> otpResult;
    try {
      otpResult = await ref.read(authProvider.notifier).verifyOtp(
            countryCode: args.countryCode,
            mobileNumber: args.mobileNumber,
            purpose: args.purpose,
            otp: state.enteredOtp,
          );
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }

    final otpFailed = otpResult.when(
      success: (_) => false,
      failure: (message, code) {
        if (ref.mounted) state = state.copyWith(hasError: true);
        UiFeedback.failure(
          l10n,
          message,
          code: code,
          fallbackTitle: l10n.errInvalidOtpTitle,
        );
        return true;
      },
    );
    if (otpFailed) return null;

    if (args.purpose == AuthPurpose.register) {
      return _completeRegistration();
    }

    state = state.copyWith(isLoading: true);
    late final AppResult<Empty> loginResult;
    try {
      loginResult = await ref.read(authProvider.notifier).completeLogin(
            countryCode: args.countryCode,
            mobileNumber: args.mobileNumber,
          );
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false);
    }

    return loginResult.when(
      success: (_) => ref.read(authProvider.notifier).getDestinationRoute(),
      failure: (message, code) {
        _fail(message, code, l10n.loginFailedTitle);
        return null;
      },
    );
  }

  Future<String?> _completeRegistration() async {
    final l10n = ref.read(l10nProvider);
    final auth = ref.read(authProvider.notifier);
    final isCustomer = args.role == UserRole.customer;

    final result = isCustomer
        ? await auth.registerCustomer(
            fullName: args.fullName ?? l10n.defaultCustomerName,
            countryCode: args.countryCode,
            mobileNumber: args.mobileNumber,
            email: args.email,
            city: args.city,
          )
        : await auth.registerSalonOwner(
            ownerFullName: args.ownerFullName ?? l10n.defaultOwnerName,
            countryCode: args.countryCode,
            ownerMobile: args.mobileNumber,
            ownerEmail: args.ownerEmail,
            salonName: args.salonName ?? l10n.defaultSalonName,
            salonType: args.salonType ?? 'Unisex Salon',
            salonContact: args.salonContact ?? args.mobileNumber,
            address: args.address ?? '',
            city: args.city ?? '',
            state: args.state ?? '',
            pincode: args.pincode ?? '',
            salonEmail: args.salonEmail,
            description: args.description,
          );

    return result.when(
      success: (_) => registrationSuccessLocation(args.role),
      failure: (message, code) {
        _fail(message, code, l10n.registrationFailedTitle);
        return null;
      },
    );
  }

  void _fail(String message, String? code, String fallbackTitle) {
    if (ref.mounted) state = state.copyWith(hasError: true);
    UiFeedback.failure(
      ref.read(l10nProvider),
      message,
      code: code,
      fallbackTitle: fallbackTitle,
    );
  }
}

/// Location of the registration success screen for [role].
String registrationSuccessLocation(UserRole role) {
  final value = role == UserRole.customer ? 'CUSTOMER' : 'SALON_OWNER';
  return '${AppRoutes.registrationSuccess}?role=$value';
}
