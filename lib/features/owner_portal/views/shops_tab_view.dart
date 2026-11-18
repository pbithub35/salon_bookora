import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/shop_model.dart';
import '../viewmodels/shops_viewmodel.dart';

class ShopsTabView extends ConsumerWidget {
  const ShopsTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final shops = ref.watch(shopsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.ownerShopCreate),
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: Text(
          l10n.addShop,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: shops.isEmpty
          ? _EmptyShops(onAdd: () => context.push(AppRoutes.ownerShopCreate))
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              itemCount: shops.length,
              separatorBuilder: (_, _) => AppSpacing.v12,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return _ShopCard(
                  shop: shop,
                  onTap: () => context.push(
                    AppRoutes.ownerShopDetailPath(shop.id),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyShops extends StatelessWidget {
  const _EmptyShops({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 56.r,
              color: AppColors.textMuted,
            ),
            AppSpacing.v16,
            AppText.title(l10n.shopsEmptyTitle),
            AppSpacing.v8,
            Text(
              l10n.shopsEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSizes.bodySmall,
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.v20,
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.addShop),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop, required this.onTap});

  final ShopModel shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.radius16,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radius16,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: AppRadius.radius16,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: AppRadius.radius12,
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primaryPurple,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.salonName,
                      style: TextStyle(
                        fontSize: AppTextSizes.titleSmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      '${shop.salonType} · ${shop.city}',
                      style: TextStyle(
                        fontSize: AppTextSizes.caption,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.v6,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: shop.setupStatus == ShopSetupStatus.setupInProgress
                            ? AppColors.warningBackground
                            : AppColors.successBackground,
                        borderRadius: AppRadius.radius20,
                      ),
                      child: Text(
                        shop.setupStatus == ShopSetupStatus.setupInProgress
                            ? context.l10n.setupInProgress
                            : context.l10n.shopReady,
                        style: TextStyle(
                          fontSize: AppTextSizes.tiny,
                          fontWeight: FontWeight.w700,
                          color: shop.setupStatus ==
                                  ShopSetupStatus.setupInProgress
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
