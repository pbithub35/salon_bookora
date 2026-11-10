import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/onboarding_viewmodel.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.welcome);
  }

  void _next() {
    if (ref.read(onboardingViewModelProvider).isLast) {
      _complete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    final state = ref.watch(onboardingViewModelProvider);
    final l10n = context.l10n;
    final slides = [
      {
        'icon': Icons.location_on_rounded,
        'title': l10n.onboardingTitle1,
        'desc': l10n.onboardingDesc1,
        'badge': l10n.onboardingBadge1,
      },
      {
        'icon': Icons.calendar_month_rounded,
        'title': l10n.onboardingTitle2,
        'desc': l10n.onboardingDesc2,
        'badge': l10n.onboardingBadge2,
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'title': l10n.onboardingTitle3,
        'desc': l10n.onboardingDesc3,
        'badge': l10n.onboardingBadge3,
      },
    ];

    return AuroraBackground(
      headerHeight: 220.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppRadius.radius20,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.spa_rounded, color: AppColors.cyan, size: 16.r),
                    AppSpacing.h6,
                    Text(
                      l10n.appName,
                      style: TextStyle(
                        fontSize: AppTextSizes.caption,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _complete,
                child: Text(
                  l10n.skip,
                  style: TextStyle(
                    fontSize: AppTextSizes.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      child: ResponsiveWrapper(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: vm.onPageChanged,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated Slide Illustration Card
                            Container(
                              width: 120.r,
                              height: 120.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEDE7FB),
                                    Color(0xFFDDD2F8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 2,
                                ),
                                boxShadow: [AppColors.softCardShadow],
                              ),
                              child: Center(
                                child: Icon(
                                  slide['icon'] as IconData,
                                  size: 54.r,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                            ),
                            AppSpacing.v16,

                            // Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSubtle,
                                borderRadius: AppRadius.radius20,
                                border: Border.all(
                                  color: AppColors.primaryPurple.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Text(
                                slide['badge'] as String,
                                style: TextStyle(
                                  fontSize: AppTextSizes.tiny,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryPurple,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            AppSpacing.v12,

                            // Title
                            AppText(
                              slide['title'] as String,
                              fontSize: AppTextSizes.headingSmall,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              color: AppColors.textPrimary,
                            ),
                            AppSpacing.v8,

                            // Description
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: AppText.body(
                                slide['desc'] as String,
                                textAlign: TextAlign.center,
                                fontSize: AppTextSizes.bodySmall,
                                color: AppColors.textSecondary,
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.totalPages,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: state.currentPage == index ? 28.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: state.currentPage == index
                          ? AppColors.primaryPurple
                          : AppColors.border,
                      borderRadius: AppRadius.radius8,
                    ),
                  ),
                ),
              ),
              AppSpacing.v24,

              // Action Button (Next or Get Started)
              AppButton.primary(
                text: state.isLast ? l10n.getStarted : l10n.next,
                onPressed: _next,
                icon: Icon(
                  state.isLast
                      ? Icons.rocket_launch_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
              AppSpacing.v12,
            ],
          ),
        ),
      ),
    );
  }
}
