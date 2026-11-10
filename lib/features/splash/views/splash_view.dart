import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final route = await ref
        .read(splashViewModelProvider.notifier)
        .resolveDestination();
    if (mounted) context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuroraBackground(
      fullScreenAurora: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Glowing App Icon
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.cyan, AppColors.neonPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.5),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppColors.neonPink.withValues(alpha: 0.4),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 92.r,
                  height: 92.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.navy,
                  ),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.cyan, AppColors.neonPink],
                      ).createShader(bounds),
                      child: Icon(
                        Icons.spa_rounded,
                        size: 48.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.v24,

            // Brand Name
            Text(
              l10n.appName,
              style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textWhite,
                letterSpacing: -0.5,
              ),
            ),
            AppSpacing.v8,

            // Tagline
            Text(
              l10n.appTagline,
              style: TextStyle(
                fontSize: AppTextSizes.titleSmall,
                fontWeight: FontWeight.w400,
                color: AppColors.cyan,
                letterSpacing: 0.8,
              ),
            ),

            const Spacer(),

            // Bottom loading indicator
            SizedBox(
              width: 28.r,
              height: 28.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.cyan,
              ),
            ),
            AppSpacing.v16,
            AppText.caption(l10n.splashLoading, color: AppColors.textWhite70),
            AppSpacing.v32,
          ],
        ),
      ),
    );
  }
}
