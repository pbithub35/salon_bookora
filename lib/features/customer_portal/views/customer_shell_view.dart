import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../../../core/utils/responsive.dart';
import '../viewmodels/customer_portal_viewmodel.dart';

class CustomerShellView extends ConsumerWidget {
  const CustomerShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedTab = ref.watch(customerPortalViewModelProvider);
    final vm = ref.read(customerPortalViewModelProvider.notifier);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.buttonGradient,
              ),
              child: Center(
                child: Text(
                  (user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'C')
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: AppTextSizes.titleSmall,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            AppSpacing.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.greetingHello(
                      user?.fullName ?? l10n.roleCustomerShort,
                    ),
                    style: TextStyle(
                      fontSize: AppTextSizes.bodyMedium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppColors.cyan,
                        size: 13.r,
                      ),
                      AppSpacing.h4,
                      Text(
                        user?.city ?? 'Mohali, Punjab',
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textWhite,
              size: 22.r,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: const Color(0xFFFF8B8B),
              size: 20.r,
            ),
            onPressed: vm.logout,
            tooltip: l10n.logoutTooltip,
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: Builder(
          builder: (context) {
            if (selectedTab == 0) {
              return _buildExploreTab(context, ref);
            } else if (selectedTab == 1) {
              return _buildPlaceholderTab(
                context,
                ref,
                l10n.tabMyAppointments,
                Icons.calendar_month_rounded,
              );
            } else if (selectedTab == 2) {
              return _buildPlaceholderTab(
                context,
                ref,
                l10n.tabSavedSalons,
                Icons.favorite_border_rounded,
              );
            } else {
              return _buildProfileTab(context, ref);
            }
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: vm.changeTab,
        backgroundColor: AppColors.surface,
        elevation: 10,
        indicatorColor: AppColors.surfaceSubtle,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(
              Icons.explore_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navBookings,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(
              Icons.favorite_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navFavorites,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreTab(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar Placeholder
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.radius14,
              border: Border.all(color: AppColors.border),
              boxShadow: [AppColors.softCardShadow],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20.r,
                ),
                AppSpacing.h10,
                Text(
                  l10n.searchHint,
                  style: TextStyle(
                    fontSize: AppTextSizes.inputHint,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v20,

          // Categories Header
          AppText.title(l10n.categoriesTitle, fontSize: AppTextSizes.title),
          AppSpacing.v12,

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryItem(l10n.catHaircut, Icons.content_cut_rounded),
                _buildCategoryItem(l10n.catSpaMassage, Icons.spa_rounded),
                _buildCategoryItem(l10n.catFacialGlow, Icons.face_rounded),
                _buildCategoryItem(l10n.catBeardGrooming, Icons.brush_rounded),
                _buildCategoryItem(l10n.catNails, Icons.back_hand_rounded),
              ],
            ),
          ),
          AppSpacing.v24,

          // Featured Salons Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.title(
                l10n.featuredSalonsTitle,
                fontSize: AppTextSizes.title,
              ),
              Text(
                l10n.viewAll,
                style: TextStyle(
                  fontSize: AppTextSizes.caption,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          AppSpacing.v14,

          // Featured Dummy Salons Cards
          _buildSalonCard(
            name: 'The Royal Spa & Unisex Studio',
            type: 'Unisex Salon & Luxury Spa',
            rating: '4.9 (128 reviews)',
            location: 'Sector 70, Mohali',
            discount: l10n.promoFirstVisit,
            bookNowLabel: l10n.bookNow,
          ),
          AppSpacing.v14,
          _buildSalonCard(
            name: 'Glow Hair Studio & Barbershop',
            type: "Men's & Women's Grooming",
            rating: '4.8 (95 reviews)',
            location: 'Phase 7, Mohali',
            discount: l10n.promoTrending,
            bookNowLabel: l10n.bookNow,
          ),
          AppSpacing.v20,
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius14,
        border: Border.all(color: AppColors.border),
        boxShadow: [AppColors.softCardShadow],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: AppColors.primaryPurple),
          AppSpacing.h8,
          Text(
            name,
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard({
    required String name,
    required String type,
    required String rating,
    required String location,
    required String discount,
    required String bookNowLabel,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius16,
        border: Border.all(color: AppColors.border),
        boxShadow: [AppColors.softCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dummy Banner
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r16),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF2C194D), Color(0xFF5700C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: AppRadius.radius8,
                    ),
                    child: Text(
                      discount,
                      style: TextStyle(
                        fontSize: AppTextSizes.tiny,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: AppRadius.radius8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 14.r,
                        ),
                        AppSpacing.h4,
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: AppTextSizes.tiny,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppTextSizes.titleSmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  type,
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.v8,
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.r,
                      color: AppColors.textMuted,
                    ),
                    AppSpacing.h4,
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: AppTextSizes.caption,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      bookNowLabel,
                      style: TextStyle(
                        fontSize: AppTextSizes.bodySmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
  ) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.r,
              color: AppColors.primaryPurple.withValues(alpha: 0.5),
            ),
            AppSpacing.v16,
            AppText.title(title),
            AppSpacing.v8,
            AppText.body(
              l10n.phase1ShellCustomerNote,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(customerPortalViewModelProvider.notifier);
    final user = ref.watch(authProvider).user;
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.v20,
          Center(
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Text(
                  (user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'U')
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.v12,
          AppText.title(user?.fullName ?? l10n.roleCustomerShort),
          AppSpacing.v4,
          Text(
            user?.fullMobile ?? '+91 9876543210',
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.v8,
          const StatusBadge(status: AccountStatusType.active),
          AppSpacing.v28,

          _buildProfileTile(
            Icons.phone_outlined,
            l10n.profileMobile,
            user?.fullMobile ?? '',
          ),
          _buildProfileTile(
            Icons.mail_outline_rounded,
            l10n.profileEmail,
            user?.email ?? l10n.notProvided,
          ),
          _buildProfileTile(
            Icons.location_city_rounded,
            l10n.city,
            user?.city ?? 'Mohali',
          ),
          AppSpacing.v32,

          AppButton.secondary(
            text: l10n.logout,
            onPressed: vm.logout,
            textColor: AppColors.error,
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primaryPurple),
          AppSpacing.h12,
          Text(
            title,
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
