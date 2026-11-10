import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/otp_input_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/otp_args.dart';
import '../viewmodels/otp_viewmodel.dart';

class OtpVerificationView extends ConsumerWidget {
  const OtpVerificationView({super.key, required this.args});

  final OtpArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = otpViewModelProvider(args);
    final vm = ref.read(provider.notifier);
    final state = ref.watch(provider);

    Future<void> verify() async {
      final route = await vm.verify();
      if (route != null && context.mounted) context.go(route);
    }

    return AuroraBackground(
      showBackButton: true,
      headerHeight: 220.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.cyan,
              size: 28.r,
            ),
          ),
          AppSpacing.v10,
          AppText.auroraHeader(l10n.otpTitle),
          AppSpacing.v4,
          AppText.auroraSubtitle(l10n.otpSubtitle),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mobile number display + Edit Number action
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: AppRadius.radius20,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_iphone_rounded,
                        size: 16.r,
                        color: AppColors.primaryPurple,
                      ),
                      AppSpacing.h6,
                      AppText(
                        '${args.countryCode} ${args.mobileNumber}',
                        fontSize: AppTextSizes.bodyMedium,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      AppSpacing.h8,
                      InkWell(
                        onTap: () => context.pop(),
                        child: Text(
                          l10n.editNumber,
                          style: TextStyle(
                            fontSize: AppTextSizes.caption,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.v28,

              // 4-Digit OTP Input
              OtpInputField(
                length: 4,
                hasError: state.hasError,
                onChanged: vm.onOtpChanged,
                onCompleted: (otp) {
                  vm.onOtpChanged(otp);
                  verify();
                },
              ),
              AppSpacing.v20,

              // Dev Mode test hint
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoBackground,
                    borderRadius: AppRadius.radius12,
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14.r,
                        color: AppColors.info,
                      ),
                      AppSpacing.h6,
                      Text(
                        l10n.devOtpHint,
                        style: TextStyle(
                          fontSize: AppTextSizes.tiny,
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.v28,

              // Resend Countdown or Action
              Center(
                child: state.canResend
                    ? TextButton.icon(
                        onPressed: vm.resendOtp,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 18.r,
                          color: AppColors.primaryPurple,
                        ),
                        label: Text(
                          l10n.resendOtp,
                          style: TextStyle(
                            fontSize: AppTextSizes.bodyMedium,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      )
                    : Text(
                        l10n.resendCodeIn(state.resendTimer),
                        style: TextStyle(
                          fontSize: AppTextSizes.bodySmall,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              AppSpacing.v32,

              // Verify Button
              AppButton.primary(
                text: l10n.verifyOtp,
                isLoading: state.isLoading,
                onPressed: verify,
                icon: const Icon(Icons.verified_rounded, color: Colors.white),
              ),
              AppSpacing.v16,
            ],
          ),
        ),
      ),
    );
  }
}
