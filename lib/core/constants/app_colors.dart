import 'package:flutter/material.dart';

/// Centralized Color Tokens for SalonBookora
/// As defined in Phase 1 Design System Specification
class AppColors {
  AppColors._();

  // Core Brand Colors
  static const Color navy = Color(0xFF080B45);
  static const Color primaryPurple = Color(0xFF8B19E8);
  static const Color deepPurple = Color(0xFF5700C8);
  static const Color cyan = Color(0xFF00E5E5);
  static const Color neonPink = Color(0xFFEC4DFF);

  // Background & Surfaces
  static const Color pageBackground = Color(0xFFF8F6FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1ECFF);
  static const Color surfaceDark = Color(0xFF131758);
  static const Color glassFill = Color(0x2AFFFFFF);

  // Typography Colors
  static const Color textPrimary = Color(0xFF101044);
  static const Color textSecondary = Color(0xFF555477);
  static const Color textMuted = Color(0xFF8E8DB0);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textWhite70 = Color(0xB3FFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE5DFFF);
  static const Color borderFocused = Color(0xFF8B19E8);
  static const Color borderSubtle = Color(0xFFF0ECFC);
  static const Color divider = Color(0xFFEFEAFE);

  // Semantic / Status Colors
  static const Color success = Color(0xFF16834A);
  static const Color successBackground = Color(0xFFE8F7ED);
  static const Color warning = Color(0xFFA65B00);
  static const Color warningBackground = Color(0xFFFFF7EB);
  static const Color error = Color(0xFFB42318);
  static const Color errorBackground = Color(0xFFFEECEB);
  static const Color info = Color(0xFF026AA2);
  static const Color infoBackground = Color(0xFFF0F9FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, deepPurple],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF9825F8), Color(0xFF6B0AE0)],
  );

  static const LinearGradient auroraGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF060938), Color(0xFF080B45), Color(0xFF140F55)],
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1F00E5E5), Color(0x1FEC4DFF)],
  );

  // Shadow Colors
  static BoxShadow primaryShadow = BoxShadow(
    color: primaryPurple.withValues(alpha: 0.28),
    blurRadius: 18,
    offset: const Offset(0, 8),
  );

  static BoxShadow softCardShadow = BoxShadow(
    color: const Color(0xFF101044).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );
}
