import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_sizes.dart';

/// Centralized Text Styles for SalonBookora
/// Built on top of AppTextSizes and AppColors for complete modularity and easy updates.
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: AppTextSizes.headingLarge,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: AppTextSizes.headingMedium,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headingSmall => GoogleFonts.inter(
    fontSize: AppTextSizes.headingSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Aurora White Headings (for dark upper header)
  static TextStyle get auroraHeading => GoogleFonts.inter(
    fontSize: AppTextSizes.headingMedium,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.3,
  );

  static TextStyle get auroraSubtitle => GoogleFonts.inter(
    fontSize: AppTextSizes.body,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite70,
    height: 1.4,
  );

  // Titles
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: AppTextSizes.titleLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: AppTextSizes.title,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: AppTextSizes.titleSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: AppTextSizes.bodyLarge,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: AppTextSizes.body,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: AppTextSizes.bodySmall,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Captions & Micro
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: AppTextSizes.caption,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle get tiny => GoogleFonts.inter(
    fontSize: AppTextSizes.tiny,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Functional Form & Button Styles
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: AppTextSizes.buttonText,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.3,
  );

  static TextStyle get inputLabel => GoogleFonts.inter(
    fontSize: AppTextSizes.inputLabel,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get inputText => GoogleFonts.inter(
    fontSize: AppTextSizes.inputText,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get inputHint => GoogleFonts.inter(
    fontSize: AppTextSizes.inputHint,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get errorText => GoogleFonts.inter(
    fontSize: AppTextSizes.errorText,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  static TextStyle get otpDigit => GoogleFonts.inter(
    fontSize: AppTextSizes.otpDigit,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
