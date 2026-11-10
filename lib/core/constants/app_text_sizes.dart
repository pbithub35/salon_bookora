import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Text Sizes Class for SalonBookora
/// All text sizes are responsive using ScreenUtil (.sp).
/// Easily modify sizes here in the future to change typography across the entire app!
class AppTextSizes {
  AppTextSizes._();

  // Micro / Badge Sizes
  static double get tiny => 10.sp;
  static double get extraSmall => 11.sp;
  static double get caption => 12.sp;

  // Body Text Sizes
  static double get bodySmall => 13.sp;
  static double get body => 14.sp;
  static double get bodyMedium => 15.sp;
  static double get bodyLarge => 16.sp;

  // Titles / Subtitles
  static double get titleSmall => 16.sp;
  static double get title => 18.sp;
  static double get titleLarge => 20.sp;

  // Headings
  static double get headingSmall => 22.sp;
  static double get headingMedium => 24.sp;
  static double get headingLarge => 28.sp;

  // Large Displays & Hero Banners
  static double get displaySmall => 32.sp;
  static double get displayMedium => 36.sp;
  static double get displayLarge => 40.sp;

  // Specific Functional UI Sizes
  static double get buttonText => 15.sp;
  static double get inputLabel => 13.sp;
  static double get inputText => 15.sp;
  static double get inputHint => 14.sp;
  static double get errorText => 12.sp;
  static double get otpDigit => 24.sp;
  static double get statusBadge => 11.sp;
  static double get appSubtitle => 13.sp;
}
