import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_sizes.dart';

/// Reusable Common Text Widget for SalonBookora
/// Built using AppTextSizes and AppColors for easy centralized typography management.
class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final TextStyle? style;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.style,
    this.decoration,
  });

  // Factory constructor for large heading
  factory AppText.heading(
    String text, {
    Key? key,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.headingLarge,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.textPrimary,
      textAlign: textAlign,
      maxLines: maxLines,
      height: 1.25,
    );
  }

  // Factory constructor for medium heading / section title
  factory AppText.title(
    String text, {
    Key? key,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.title,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  // Factory constructor for body text
  factory AppText.body(
    String text, {
    Key? key,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    FontWeight? fontWeight,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.body,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? AppColors.textSecondary,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      height: 1.5,
    );
  }

  // Factory constructor for small caption / sub-label
  factory AppText.caption(
    String text, {
    Key? key,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    FontWeight? fontWeight,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.caption,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textMuted,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  // Factory constructor for Aurora header title (white with glow-readability)
  factory AppText.auroraHeader(
    String text, {
    Key? key,
    double? fontSize,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.headingMedium,
      fontWeight: FontWeight.w700,
      color: AppColors.textWhite,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      letterSpacing: -0.2,
    );
  }

  // Factory constructor for Aurora header subtitle
  factory AppText.auroraSubtitle(
    String text, {
    Key? key,
    double? fontSize,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: fontSize ?? AppTextSizes.body,
      fontWeight: FontWeight.w400,
      color: AppColors.textWhite70,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      height: 1.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = (style ?? GoogleFonts.inter()).copyWith(
      fontSize: fontSize ?? AppTextSizes.body,
      color: color ?? AppColors.textPrimary,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: effectiveStyle,
    );
  }
}
