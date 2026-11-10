import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/role_selection_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/user_model.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/role_selection_viewmodel.dart';

class RoleSelectionView extends ConsumerWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedRole = ref.watch(roleSelectionViewModelProvider);
    final vm = ref.read(roleSelectionViewModelProvider.notifier);

    return AuroraBackground(
      showBackButton: true,
      headerHeight: 220.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.group_rounded, color: AppColors.cyan, size: 28.r),
          ),
          AppSpacing.v10,
          AppText.auroraHeader(l10n.selectAccountType),
          AppSpacing.v4,
          AppText.auroraSubtitle(l10n.selectRoleSubtitle),
        ],
      ),
      child: ResponsiveWrapper(
        child: Padding(
          padding: AppSpacing.formPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText.title(
                l10n.roleHowToUseTitle,
                fontSize: AppTextSizes.titleLarge,
              ),
              AppSpacing.v8,
              AppText.body(
                l10n.roleHowToUseSubtitle,
                color: AppColors.textSecondary,
              ),
              AppSpacing.v24,

              // Option 1: Customer Card
              RoleSelectionCard(
                title: l10n.customerTitle,
                description: l10n.customerDesc,
                icon: Icons.person_rounded,
                isSelected: selectedRole == UserRole.customer,
                onTap: () => vm.selectRole(UserRole.customer),
              ),
              AppSpacing.v16,

              // Option 2: Salon Owner Card
              RoleSelectionCard(
                title: l10n.salonOwnerTitle,
                description: l10n.salonOwnerDesc,
                icon: Icons.storefront_rounded,
                badgeText: l10n.freeTrialBadge,
                isSelected: selectedRole == UserRole.salonOwner,
                onTap: () => vm.selectRole(UserRole.salonOwner),
              ),
              const Spacer(),

              // Continue Button
              AppButton.primary(
                text: l10n.continueText,
                onPressed: () => context.push(vm.nextRoute),
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
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
