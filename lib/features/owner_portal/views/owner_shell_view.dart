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
import '../viewmodels/owner_portal_viewmodel.dart';

class OwnerShellView extends ConsumerWidget {
  const OwnerShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedTab = ref.watch(ownerPortalViewModelProvider);
    final vm = ref.read(ownerPortalViewModelProvider.notifier);
    final salon = ref.watch(authProvider).salon;
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
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: AppRadius.radius10,
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: AppColors.cyan,
                size: 20.r,
              ),
            ),
            AppSpacing.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon?.salonName ?? 'Royal Salon & Spa',
                    style: TextStyle(
                      fontSize: AppTextSizes.bodyMedium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  Text(
                    l10n.partnerPortalTitle(
                      user?.fullName ?? l10n.roleOwnerShort,
                    ),
                    style: TextStyle(
                      fontSize: AppTextSizes.caption,
                      color: AppColors.cyan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
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
              return _buildDashboardTab(context, ref, salon, user);
            } else if (selectedTab == 1) {
              return _buildPlaceholderTab(
                context,
                ref,
                l10n.tabAppointmentsCalendar,
                Icons.event_note_rounded,
              );
            } else if (selectedTab == 2) {
              return _buildPlaceholderTab(
                context,
                ref,
                l10n.tabServicesPricing,
                Icons.spa_rounded,
              );
            } else {
              return _buildProfileTab(context, ref, salon, user);
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navBookings,
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(
              Icons.spa_rounded,
              color: AppColors.primaryPurple,
            ),
            label: l10n.navServices,
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

  Widget _buildDashboardTab(
    BuildContext context,
    WidgetRef ref,
    dynamic salon,
    dynamic user,
  ) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3-Month Free Trial Banner as per Phase 1 Spec Section 4.1 & 9.7
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5700C8), Color(0xFF8B19E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.radius16,
              boxShadow: [AppColors.primaryShadow],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.card_membership_rounded,
                    color: AppColors.cyan,
                    size: 26.r,
                  ),
                ),
                AppSpacing.h14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.freeTrialLabel,
                            style: TextStyle(
                              fontSize: AppTextSizes.titleSmall,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.h8,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cyan,
                              borderRadius: AppRadius.radius4,
                            ),
                            child: Text(
                              l10n.badgeActive,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.v4,
                      Text(
                        l10n.trialNote,
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v20,

          // Status & Verification Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.title(
                l10n.businessOverview,
                fontSize: AppTextSizes.title,
              ),
              StatusBadge(
                status: AccountStatusType.approved,
                customLabel: l10n.badgeVerifiedPartner,
              ),
            ],
          ),
          AppSpacing.v14,

          // Quick Metric Cards Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: l10n.metricTodaysBookings,
                  value: '0',
                  icon: Icons.calendar_today_rounded,
                  color: AppColors.primaryPurple,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: _buildMetricCard(
                  title: l10n.metricRevenueToday,
                  value: '₹0',
                  icon: Icons.currency_rupee_rounded,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: l10n.metricActiveStylists,
                  value: '0',
                  icon: Icons.people_alt_rounded,
                  color: AppColors.info,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: _buildMetricCard(
                  title: l10n.metricSalonRating,
                  value: '5.0 ★',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          AppSpacing.v24,

          // Quick Actions
          AppText.title(l10n.quickManagement, fontSize: AppTextSizes.title),
          AppSpacing.v12,

          _buildActionTile(
            title: l10n.actionManageServices,
            subtitle: l10n.actionManageServicesDesc,
            icon: Icons.spa_outlined,
          ),
          AppSpacing.v10,
          _buildActionTile(
            title: l10n.actionStaffScheduling,
            subtitle: l10n.actionStaffSchedulingDesc,
            icon: Icons.group_outlined,
          ),
          AppSpacing.v10,
          _buildActionTile(
            title: l10n.actionSalonProfile,
            subtitle:
                '${salon?.address ?? "SCO 42"}, ${salon?.city ?? "Mohali"}',
            icon: Icons.store_mall_directory_outlined,
          ),
          AppSpacing.v20,
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius16,
        border: Border.all(color: AppColors.border),
        boxShadow: [AppColors.softCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTextSizes.caption,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20.r),
            ],
          ),
          AppSpacing.v10,
          Text(
            value,
            style: TextStyle(
              fontSize: AppTextSizes.headingMedium,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius14,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: AppRadius.radius10,
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 22.r),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTextSizes.bodySmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
              l10n.phase1ShellOwnerNote,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(
    BuildContext context,
    WidgetRef ref,
    dynamic salon,
    dynamic user,
  ) {
    final l10n = context.l10n;
    final vm = ref.read(ownerPortalViewModelProvider.notifier);
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
                child: Icon(
                  Icons.storefront_rounded,
                  size: 40.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AppSpacing.v12,
          AppText.title(salon?.salonName ?? 'Registered Salon'),
          AppSpacing.v4,
          Text(
            salon?.salonType ?? 'Unisex Salon',
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.v8,
          const StatusBadge(status: AccountStatusType.approved),
          AppSpacing.v28,

          _buildProfileTile(
            Icons.person_outline_rounded,
            l10n.profileOwnerName,
            user?.fullName ?? '',
          ),
          _buildProfileTile(
            Icons.phone_outlined,
            l10n.profileOwnerPhone,
            user?.fullMobile ?? '',
          ),
          _buildProfileTile(
            Icons.mail_outline_rounded,
            l10n.profileEmail,
            user?.email ?? l10n.notProvided,
          ),
          _buildProfileTile(
            Icons.location_on_outlined,
            l10n.profileCityState,
            '${salon?.city ?? "Mohali"}, ${salon?.state ?? "Punjab"}',
          ),
          _buildProfileTile(
            Icons.pin_drop_outlined,
            l10n.pincode,
            salon?.pincode ?? '160071',
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
