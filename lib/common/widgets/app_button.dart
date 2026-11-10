import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';

enum ButtonType { primary, secondary, text }

/// Professional Reusable Button for SalonBookora
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Gradient? gradient;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.gradient,
  });

  // Factory constructor for primary gradient button
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
    double? height,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
    );
  }

  // Factory constructor for secondary outline button
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
    double? height,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  // Factory constructor for text button
  factory AppButton.text({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Color? textColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      icon: icon,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppSpacing.buttonHeight;
    final effectiveRadius = borderRadius ?? AppRadius.radius14;
    final isEnabled = onPressed != null && !isLoading;

    if (type == ButtonType.text) {
      return TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primaryPurple,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, AppSpacing.h6],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: AppTextSizes.buttonText,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      );
    }

    if (type == ButtonType.secondary) {
      final effectiveColor = textColor ?? AppColors.primaryPurple;
      return SizedBox(
        width: width ?? double.infinity,
        height: effectiveHeight,
        child: OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.surface,
            side: BorderSide(
              color: isEnabled ? effectiveColor : AppColors.border,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: effectiveRadius),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: effectiveColor,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, AppSpacing.h8],
                    Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: AppTextSizes.buttonText,
                        fontWeight: FontWeight.w600,
                        color: effectiveColor,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    // Primary Gradient Button
    return Container(
      width: width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? (gradient ?? AppColors.buttonGradient)
            : const LinearGradient(
                colors: [Color(0xFFC7B8E8), Color(0xFFA898D6)],
              ),
        borderRadius: effectiveRadius,
        boxShadow: isEnabled ? [AppColors.primaryShadow] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: effectiveRadius,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.textWhite,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[icon!, AppSpacing.h8],
                      Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: AppTextSizes.buttonText,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                          letterSpacing: 0.3,
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
