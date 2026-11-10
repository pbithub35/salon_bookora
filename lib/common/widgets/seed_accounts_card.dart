import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import '../../core/utils/l10n_extension.dart';

/// Phase 1 dev helper: 1-tap fill of seed mobile numbers (OTP 0000).
class SeedAccountsCard extends StatelessWidget {
  const SeedAccountsCard({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppRadius.radius14,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: 16.r,
                color: AppColors.primaryPurple,
              ),
              AppSpacing.h6,
              Text(
                l10n.seedAccountsTitle,
                style: TextStyle(
                  fontSize: AppTextSizes.tiny,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          AppSpacing.v8,
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _chip(l10n.seedCustomer, AppConstants.seedCustomerMobile),
              _chip(l10n.seedOwnerPending, AppConstants.seedOwnerPendingMobile),
              _chip(
                l10n.seedOwnerApproved,
                AppConstants.seedOwnerApprovedMobile,
              ),
              _chip(
                l10n.seedOwnerRejected,
                AppConstants.seedOwnerRejectedMobile,
              ),
              _chip(l10n.seedSuspended, AppConstants.seedSuspendedMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String number) {
    return InkWell(
      onTap: () => onSelected(number),
      borderRadius: AppRadius.radius8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radius8,
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          '$label ($number)',
          style: TextStyle(
            fontSize: AppTextSizes.tiny,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
