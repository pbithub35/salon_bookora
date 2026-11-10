import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../viewmodels/status_viewmodel.dart';

class PendingApprovalView extends ConsumerWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(statusViewModelProvider.notifier);
    final isChecking = ref.watch(statusViewModelProvider);
    final salon = ref.watch(authProvider).salon;
    final user = ref.watch(authProvider).user;

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
                color: AppColors.warning.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: const Color(0xFFFFB300),
              size: 40.r,
            ),
          ),
          AppSpacing.v12,
          AppText.auroraHeader(l10n.pendingApprovalTitle),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge
              Center(
                child: StatusBadge(
                  status: AccountStatusType.pending,
                  customLabel: l10n.badgeApplicationUnderReview,
                ),
              ),
              AppSpacing.v20,

              // Salon Details Card
              Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radius16,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [AppColors.softCardShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: AppRadius.radius12,
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.primaryPurple,
                            size: 24.r,
                          ),
                        ),
                        AppSpacing.h12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                salon?.salonName ?? 'Registered Salon',
                                style: TextStyle(
                                  fontSize: AppTextSizes.titleSmall,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.v2,
                              Text(
                                salon?.salonType ?? 'Unisex Salon',
                                style: TextStyle(
                                  fontSize: AppTextSizes.caption,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      l10n.infoOwnerName,
                      user?.fullName ?? 'Owner',
                    ),
                    AppSpacing.v8,
                    _buildInfoRow(
                      l10n.infoContactNumber,
                      user?.fullMobile ?? '9876543210',
                    ),
                    AppSpacing.v8,
                    _buildInfoRow(
                      l10n.infoLocation,
                      '${salon?.city ?? 'Mohali'}, ${salon?.state ?? 'Punjab'}',
                    ),
                    AppSpacing.v8,
                    _buildInfoRow(
                      l10n.infoEstimatedReview,
                      l10n.infoReviewDuration,
                    ),
                  ],
                ),
              ),
              AppSpacing.v20,

              // Notice
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.warningBackground,
                  borderRadius: AppRadius.radius14,
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 20.r,
                      color: AppColors.warning,
                    ),
                    AppSpacing.h10,
                    Expanded(
                      child: Text(
                        l10n.pendingApprovalDesc,
                        style: TextStyle(
                          fontSize: AppTextSizes.bodySmall,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.v32,

              // Check Status Button
              AppButton.primary(
                text: l10n.checkStatus,
                isLoading: isChecking,
                onPressed: () async {
                  final approved = await vm.checkApprovalStatus();
                  if (approved && context.mounted) {
                    context.go(AppRoutes.ownerShell);
                  }
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTextSizes.caption,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTextSizes.caption,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
