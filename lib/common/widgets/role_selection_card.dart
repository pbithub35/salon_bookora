import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import 'app_text.dart';

/// Interactive Role Selection Card (Customer vs Salon Owner)
class RoleSelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badgeText;

  const RoleSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceSubtle : AppColors.surface,
        borderRadius: AppRadius.radius20,
        border: Border.all(
          color: isSelected ? AppColors.primaryPurple : AppColors.border,
          width: isSelected ? 2.0 : 1.2,
        ),
        boxShadow: [
          if (isSelected) AppColors.primaryShadow else AppColors.softCardShadow,
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radius20,
          child: Padding(
            padding: EdgeInsets.all(18.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.buttonGradient
                        : const LinearGradient(
                            colors: [Color(0xFFEDE7FB), Color(0xFFE2D6F8)],
                          ),
                    borderRadius: AppRadius.radius16,
                  ),
                  child: Icon(
                    icon,
                    size: 26.r,
                    color: isSelected
                        ? AppColors.textWhite
                        : AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.h16,

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              title,
                              fontSize: AppTextSizes.titleSmall,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          // Radio indicator
                          Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryPurple
                                    : AppColors.textMuted,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12.r,
                                      height: 12.r,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryPurple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                      if (badgeText != null) ...[
                        AppSpacing.v6,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warningBackground,
                            borderRadius: AppRadius.radius6,
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              fontSize: AppTextSizes.tiny,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                      AppSpacing.v8,
                      AppText.body(
                        description,
                        fontSize: AppTextSizes.bodySmall,
                        color: AppColors.textSecondary,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
