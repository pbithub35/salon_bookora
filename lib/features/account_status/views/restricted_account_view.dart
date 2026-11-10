import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/ui_feedback.dart';
import '../viewmodels/status_viewmodel.dart';

class RestrictedAccountView extends ConsumerWidget {
  const RestrictedAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(statusViewModelProvider.notifier);
    return AuroraBackground(
      headerHeight: 240.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF912018).withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.lock_rounded,
              color: const Color(0xFFFF6B6B),
              size: 40.r,
            ),
          ),
          AppSpacing.v12,
          AppText.auroraHeader(l10n.restrictedTitle),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: StatusBadge(
                  status: AccountStatusType.suspended,
                  customLabel: l10n.badgeAccountRestricted,
                ),
              ),
              AppSpacing.v24,

              Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEECEB),
                  borderRadius: AppRadius.radius16,
                  border: Border.all(color: const Color(0xFFFDA29B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accessSuspended,
                      style: TextStyle(
                        fontSize: AppTextSizes.titleSmall,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF912018),
                      ),
                    ),
                    AppSpacing.v8,
                    Text(
                      l10n.restrictedDesc,
                      style: TextStyle(
                        fontSize: AppTextSizes.bodyMedium,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.v20,

              AppText.body(
                l10n.restrictedHelpText,
                color: AppColors.textSecondary,
              ),
              AppSpacing.v36,

              // Contact Support Button
              AppButton.primary(
                text: l10n.contactSecurityTeam,
                onPressed: () {
                  UiFeedback.info(
                    l10n.supportRequestTitle,
                    l10n.supportRequestMessage,
                  );
                },
                icon: const Icon(
                  Icons.mail_outline_rounded,
                  color: Colors.white,
                ),
              ),
              AppSpacing.v16,

              // Logout Button
              AppButton.secondary(
                text: l10n.logout,
                onPressed: vm.logout,
                textColor: AppColors.error,
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              ),
              AppSpacing.v16,
            ],
          ),
        ),
      ),
    );
  }
}
