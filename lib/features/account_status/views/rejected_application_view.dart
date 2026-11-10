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
import '../../auth/viewmodels/auth_notifier.dart';
import '../viewmodels/status_viewmodel.dart';

class RejectedApplicationView extends ConsumerWidget {
  const RejectedApplicationView({super.key});

  void _showSupportDialog(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topSheet),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: AppRadius.radius8,
                    ),
                  ),
                ),
                AppSpacing.v16,
                AppText.title(l10n.partnerSupportTitle),
                AppSpacing.v12,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.email_outlined,
                    color: AppColors.primaryPurple,
                  ),
                  title: const Text('partners@salonbookora.com'),
                  subtitle: Text(l10n.supportResponseTime),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.primaryPurple,
                  ),
                  title: Text(l10n.supportTollFree),
                  subtitle: Text(l10n.supportHours),
                ),
                AppSpacing.v20,
                AppButton.primary(
                  text: l10n.close,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(statusViewModelProvider.notifier);
    final salon = ref.watch(authProvider).salon;

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
                color: AppColors.error.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.highlight_off_rounded,
              color: const Color(0xFFFF5252),
              size: 40.r,
            ),
          ),
          AppSpacing.v12,
          AppText.auroraHeader(l10n.rejectedTitle),
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
                  status: AccountStatusType.rejected,
                  customLabel: l10n.badgeApplicationNotApproved,
                ),
              ),
              AppSpacing.v20,

              // Rejection Reason Box
              Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: AppColors.errorBackground,
                  borderRadius: AppRadius.radius16,
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 20.r,
                        ),
                        AppSpacing.h8,
                        Text(
                          l10n.rejectionReasonLabel,
                          style: TextStyle(
                            fontSize: AppTextSizes.caption,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v10,
                    Text(
                      salon?.rejectionReason ?? l10n.rejectionFallbackReason,
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
                l10n.rejectedHelpText,
                color: AppColors.textSecondary,
              ),
              AppSpacing.v32,

              // Contact Support Button
              AppButton.primary(
                text: l10n.contactSupport,
                onPressed: () => _showSupportDialog(context),
                icon: const Icon(
                  Icons.support_agent_rounded,
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
