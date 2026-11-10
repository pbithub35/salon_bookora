import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'otp_args.dart';

class SalonOwnerRegisterState {
  const SalonOwnerRegisterState({
    this.currentStep = 1,
    this.isLoading = false,
    this.countryCode = '+91',
    required this.salonType,
  });

  final int currentStep;
  final bool isLoading;
  final String countryCode;
  final String salonType;

  SalonOwnerRegisterState copyWith({
    int? currentStep,
    bool? isLoading,
    String? countryCode,
    String? salonType,
  }) => SalonOwnerRegisterState(
    currentStep: currentStep ?? this.currentStep,
    isLoading: isLoading ?? this.isLoading,
    countryCode: countryCode ?? this.countryCode,
    salonType: salonType ?? this.salonType,
  );
}

final salonOwnerRegisterViewModelProvider =
    NotifierProvider.autoDispose<
      SalonOwnerRegisterViewModel,
      SalonOwnerRegisterState
    >(SalonOwnerRegisterViewModel.new);

class SalonOwnerRegisterViewModel extends Notifier<SalonOwnerRegisterState> {
  @override
  SalonOwnerRegisterState build() =>
      SalonOwnerRegisterState(salonType: AppConstants.salonTypes.first);

  void setCountryCode(String code) {
    state = state.copyWith(countryCode: code);
  }

  void setSalonType(String type) {
    state = state.copyWith(salonType: type);
  }

  void goToStep2() => state = state.copyWith(currentStep: 2);

  void goToStep1() => state = state.copyWith(currentStep: 1);

  /// Sends the registration OTP for the owner application.
  /// Returns OTP args on success, else `null`.
  Future<OtpArgs?> submit({
    required String ownerFullName,
    required String ownerMobile,
    required String ownerEmail,
    required String salonName,
    required String salonContact,
    required String address,
    required String city,
    required String stateName,
    required String pincode,
    String? salonEmail,
    String? description,
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
        salonName: salonName,
        salonType: state.salonType,
        salonContact: salonContact,
        address: address,
        city: city,
        state: stateName,
        pincode: pincode,
        salonEmail:
            (salonEmail == null || salonEmail.isEmpty) ? null : salonEmail,
        description: (description == null || description.isEmpty)
            ? null
            : description,
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
