import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Responsive Spacing & Dimensions for SalonBookora
/// Uses 8px grid system with 2-4px micro-adjustments as specified in design system.
class AppSpacing {
  AppSpacing._();

  // Raw numeric values (scaled)
  static double get s2 => 2.h;
  static double get s4 => 4.h;
  static double get s6 => 6.h;
  static double get s8 => 8.h;
  static double get s10 => 10.h;
  static double get s12 => 12.h;
  static double get s14 => 14.h;
  static double get s16 => 16.h;
  static double get s20 => 20.h;
  static double get s24 => 24.h;
  static double get s28 => 28.h;
  static double get s32 => 32.h;
  static double get s36 => 36.h;
  static double get s40 => 40.h;
  static double get s48 => 48.h;
  static double get s56 => 56.h;
  static double get s64 => 64.h;

  // Horizontal Sized Boxes
  static Widget get h4 => SizedBox(width: 4.w);
  static Widget get h6 => SizedBox(width: 6.w);
  static Widget get h8 => SizedBox(width: 8.w);
  static Widget get h10 => SizedBox(width: 10.w);
  static Widget get h12 => SizedBox(width: 12.w);
  static Widget get h14 => SizedBox(width: 14.w);
  static Widget get h16 => SizedBox(width: 16.w);
  static Widget get h20 => SizedBox(width: 20.w);
  static Widget get h24 => SizedBox(width: 24.w);
  static Widget get h32 => SizedBox(width: 32.w);

  // Vertical Sized Boxes
  static Widget get v2 => SizedBox(height: 2.h);
  static Widget get v4 => SizedBox(height: 4.h);
  static Widget get v6 => SizedBox(height: 6.h);
  static Widget get v8 => SizedBox(height: 8.h);
  static Widget get v10 => SizedBox(height: 10.h);
  static Widget get v12 => SizedBox(height: 12.h);
  static Widget get v14 => SizedBox(height: 14.h);
  static Widget get v16 => SizedBox(height: 16.h);
  static Widget get v20 => SizedBox(height: 20.h);
  static Widget get v24 => SizedBox(height: 24.h);
  static Widget get v28 => SizedBox(height: 28.h);
  static Widget get v32 => SizedBox(height: 32.h);
  static Widget get v36 => SizedBox(height: 36.h);
  static Widget get v40 => SizedBox(height: 40.h);
  static Widget get v48 => SizedBox(height: 48.h);

  // Standard Screen Paddings
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h);
  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get formPadding =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h);
  static EdgeInsets get cardPadding => EdgeInsets.all(16.r);
  static EdgeInsets get cardPaddingLarge => EdgeInsets.all(20.r);
  static EdgeInsets get inputPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);
  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h);

  // Standard Element Heights
  static double get buttonHeight => 52.h;
  static double get inputHeight => 52.h;
  static double get headerMinHeight => 220.h;
}
