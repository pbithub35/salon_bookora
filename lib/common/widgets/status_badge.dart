import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import '../../core/utils/l10n_extension.dart';

enum AccountStatusType { pending, approved, rejected, suspended, active }

/// Status Badge Pill Widget for Salon & User Statuses
class StatusBadge extends StatelessWidget {
  final AccountStatusType status;
  final String? customLabel;

  const StatusBadge({super.key, required this.status, this.customLabel});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status) {
      case AccountStatusType.pending:
        bgColor = AppColors.warningBackground;
        textColor = AppColors.warning;
        icon = Icons.access_time_rounded;
        label = customLabel ?? l10n.badgePendingReview;
        break;
      case AccountStatusType.approved:
        bgColor = AppColors.successBackground;
        textColor = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        label = customLabel ?? l10n.badgeApproved;
        break;
      case AccountStatusType.rejected:
        bgColor = AppColors.errorBackground;
        textColor = AppColors.error;
        icon = Icons.highlight_off_rounded;
        label = customLabel ?? l10n.badgeApplicationRejected;
        break;
      case AccountStatusType.suspended:
        bgColor = const Color(0xFFFEECEB);
        textColor = const Color(0xFF912018);
        icon = Icons.lock_outline_rounded;
        label = customLabel ?? l10n.badgeRestricted;
        break;
      case AccountStatusType.active:
        bgColor = AppColors.successBackground;
        textColor = AppColors.success;
        icon = Icons.verified_rounded;
        label = customLabel ?? l10n.badgeActive;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.radius20,
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14.r),
          AppSpacing.h6,
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.statusBadge,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
