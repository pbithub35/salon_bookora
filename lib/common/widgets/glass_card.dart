import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';

/// Reusable Glassmorphism Card with subtle border and optional shadow
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double blur;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.blur = 10,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.radius16;

    final content = ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surface,
            borderRadius: effectiveRadius,
            border: Border.all(
              color: borderColor ?? AppColors.border,
              width: 1.2,
            ),
            boxShadow: [AppColors.softCardShadow],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: content,
        ),
      );
    }

    return Container(margin: margin, child: content);
  }
}
