import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Border Radius Tokens for SalonBookora
/// Designed for 16-24px rounded card aesthetics from the official reference.
class AppRadius {
  AppRadius._();

  // Raw Values
  static double get r4 => 4.r;
  static double get r6 => 6.r;
  static double get r8 => 8.r;
  static double get r10 => 10.r;
  static double get r12 => 12.r;
  static double get r14 => 14.r;
  static double get r16 => 16.r;
  static double get r20 => 20.r;
  static double get r24 => 24.r;
  static double get r28 => 28.r;
  static double get r32 => 32.r;
  static double get rCircle => 999.r;

  // BorderRadius objects
  static BorderRadius get radius4 => BorderRadius.circular(4.r);
  static BorderRadius get radius6 => BorderRadius.circular(6.r);
  static BorderRadius get radius8 => BorderRadius.circular(8.r);
  static BorderRadius get radius10 => BorderRadius.circular(10.r);
  static BorderRadius get radius12 => BorderRadius.circular(12.r);
  static BorderRadius get radius14 => BorderRadius.circular(14.r);
  static BorderRadius get radius16 => BorderRadius.circular(16.r);
  static BorderRadius get radius20 => BorderRadius.circular(20.r);
  static BorderRadius get radius24 => BorderRadius.circular(24.r);
  static BorderRadius get radius28 => BorderRadius.circular(28.r);
  static BorderRadius get radius32 => BorderRadius.circular(32.r);
  static BorderRadius get radiusCircle => BorderRadius.circular(999.r);

  // Top Rounded Card Sheets
  static BorderRadius get topSheet => BorderRadius.only(
    topLeft: Radius.circular(28.r),
    topRight: Radius.circular(28.r),
  );

  static BorderRadius get bottomSheet => BorderRadius.only(
    bottomLeft: Radius.circular(28.r),
    bottomRight: Radius.circular(28.r),
  );
}
