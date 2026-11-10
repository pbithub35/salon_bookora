import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/auth_notifier.dart';
import '../../../core/utils/responsive.dart';

class RegistrationSuccessView extends ConsumerWidget {
  const RegistrationSuccessView({super.key, required this.isCustomer});

  final bool isCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return AuroraBackground(
      headerHeight: 260.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.cyan, Color(0xFF16834A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.4),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 46.r),
          ),
          AppSpacing.v16,
          AppText.auroraHeader(l10n.registrationSuccess),
        ],
      ),
      child: ResponsiveWrapper(
        child: Padding(
          padding: AppSpacing.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.v16,
              Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: AppRadius.radius16,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.success,
                      size: 28.r,
                    ),
                    AppSpacing.h12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCustomer
                                ? l10n.accountActivated
                                : l10n.applicationReceived,
                            style: TextStyle(
                              fontSize: AppTextSizes.titleSmall,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                          AppSpacing.v4,
                          Text(
                            isCustomer
                                ? l10n.customerSuccessDesc
                                : l10n.ownerSuccessDesc,
                            style: TextStyle(
                              fontSize: AppTextSizes.bodySmall,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.v24,

              AppText.body(
                isCustomer ? l10n.customerSuccessNote : l10n.ownerSuccessNote,
                color: AppColors.textSecondary,
              ),

              const Spacer(),

              AppButton.primary(
                text: l10n.continueToPortal,
                onPressed: () => context.go(
                  ref.read(authProvider.notifier).getDestinationRoute(),
                ),
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
              AppSpacing.v16,
            ],
          ),
        ),
      ),
    );
  }
}
