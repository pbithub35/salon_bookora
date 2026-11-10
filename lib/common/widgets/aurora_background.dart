import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';

/// Pixel-perfect Locked Aurora Background for SalonBookora
/// Renders deep midnight navy base (#080B45), top-right cyan glow (#00E5E5),
/// left purple/magenta glow (#EC4DFF / #8B19E8), and organic neon wave curves.
class AuroraBackground extends StatelessWidget {
  final Widget? headerContent;
  final Widget child;
  final double? headerHeight;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool fullScreenAurora;
  final EdgeInsetsGeometry? contentPadding;

  /// Optional trailing widget in the header's top row (e.g. LanguageSelector).
  final Widget? headerAction;

  const AuroraBackground({
    super.key,
    this.headerContent,
    required this.child,
    this.headerHeight,
    this.showBackButton = false,
    this.onBack,
    this.fullScreenAurora = false,
    this.contentPadding,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeaderHeight = headerHeight ?? 240.h;

    if (fullScreenAurora) {
      return Scaffold(
        backgroundColor: AppColors.navy,
        body: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _AuroraWavesPainter())),
            SafeArea(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          // Upper Aurora Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: effectiveHeaderHeight + 40.h,
            child: Stack(
              children: [
                Positioned.fill(child: Container(color: AppColors.navy)),
                Positioned.fill(
                  child: CustomPaint(painter: _AuroraWavesPainter()),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showBackButton || headerAction != null)
                          Row(
                            children: [
                              if (showBackButton)
                                InkWell(
                                  onTap:
                                      onBack ??
                                      () => Navigator.of(context).maybePop(),
                                  borderRadius: AppRadius.radiusCircle,
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.25,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: AppColors.textWhite,
                                      size: 18.r,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              ?headerAction,
                            ],
                          ),
                        if (headerContent != null)
                          Expanded(child: Center(child: headerContent!)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lower Content Panel (White/Lavender Rounded Surface)
          Positioned(
            top: effectiveHeaderHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: AppRadius.topSheet,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: AppRadius.topSheet,
                child: Padding(
                  padding: contentPadding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter creating the locked Aurora glow and flowing waves
class _AuroraWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base gradient
    final basePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.2, -0.4),
        radius: 1.2,
        colors: [Color(0xFF0F1560), Color(0xFF080B45), Color(0xFF040628)],
      ).createShader(rect);
    canvas.drawRect(rect, basePaint);

    // 2. Cyan Glow (Concentrated top-right)
    final cyanPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.85, -0.65),
        radius: 0.8,
        colors: [
          AppColors.cyan.withValues(alpha: 0.55),
          AppColors.cyan.withValues(alpha: 0.20),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(rect, cyanPaint);

    // 3. Magenta/Pink Glow (Left & upper-left)
    final magentaPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, -0.3),
        radius: 0.85,
        colors: [
          AppColors.neonPink.withValues(alpha: 0.45),
          AppColors.primaryPurple.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(rect, magentaPaint);

    // 4. Deep Violet Glow (Bottom-center aurora depth)
    final violetPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.6),
        radius: 0.9,
        colors: [
          AppColors.deepPurple.withValues(alpha: 0.40),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(rect, violetPaint);

    // 5. Flowing Neon Aurora Wave 1 (Cyan/Teal wave)
    final wave1Path = Path();
    wave1Path.moveTo(0, size.height * 0.55);
    wave1Path.cubicTo(
      size.width * 0.28,
      size.height * 0.35,
      size.width * 0.65,
      size.height * 0.75,
      size.width,
      size.height * 0.48,
    );
    wave1Path.lineTo(size.width, size.height);
    wave1Path.lineTo(0, size.height);
    wave1Path.close();

    final wave1Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cyan.withValues(alpha: 0.25),
          AppColors.primaryPurple.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.plus;
    canvas.drawPath(wave1Path, wave1Paint);

    // 6. Flowing Neon Aurora Wave 2 (Magenta/Pink curve)
    final wave2Path = Path();
    wave2Path.moveTo(0, size.height * 0.72);
    wave2Path.cubicTo(
      size.width * 0.35,
      size.height * 0.88,
      size.width * 0.70,
      size.height * 0.42,
      size.width,
      size.height * 0.62,
    );
    wave2Path.lineTo(size.width, size.height);
    wave2Path.lineTo(0, size.height);
    wave2Path.close();

    final wave2Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          AppColors.neonPink.withValues(alpha: 0.22),
          AppColors.cyan.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.plus;
    canvas.drawPath(wave2Path, wave2Paint);

    // 7. Glowing Edge Wave Line
    final waveLinePath = Path();
    waveLinePath.moveTo(0, size.height * 0.65);
    waveLinePath.cubicTo(
      size.width * 0.30,
      size.height * 0.50,
      size.width * 0.68,
      size.height * 0.78,
      size.width,
      size.height * 0.55,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = const LinearGradient(
        colors: [AppColors.neonPink, AppColors.cyan],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
    canvas.drawPath(waveLinePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
