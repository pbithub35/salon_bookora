import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_text_sizes.dart';
import 'app_text.dart';

/// Reusable App Bar for SalonBookora
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isDark;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveForeground =
        foregroundColor ??
        (isDark ? AppColors.textWhite : AppColors.textPrimary);

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? Padding(
              padding: EdgeInsets.all(8.r),
              child: InkWell(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                borderRadius: AppRadius.radiusCircle,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: effectiveForeground,
                    size: 16.r,
                  ),
                ),
              ),
            )
          : null,
      title: title != null
          ? AppText(
              title!,
              fontSize: AppTextSizes.title,
              fontWeight: FontWeight.w700,
              color: effectiveForeground,
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
