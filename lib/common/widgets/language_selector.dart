import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import '../../core/utils/l10n_extension.dart';

/// Reusable language picker (en / hi / pa) backed by the Riverpod
/// `localeProvider`. Shown on Welcome and later Settings/Profile.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static String nameFor(BuildContext context, Locale locale) {
    final l10n = context.l10n;
    return switch (locale.languageCode) {
      'hi' => l10n.languageHindi,
      'pa' => l10n.languagePunjabi,
      _ => l10n.languageEnglish,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final locales = [
      for (final code in const ['en', 'hi', 'pa']) Locale(code),
    ];

    return PopupMenuButton<Locale>(
      tooltip: context.l10n.selectLanguage,
      initialValue: current,
      onSelected: (locale) =>
          ref.read(localeProvider.notifier).setLocale(locale),
      itemBuilder: (context) => [
        for (final locale in locales)
          PopupMenuItem<Locale>(
            value: locale,
            child: Text(nameFor(context, locale)),
          ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: AppRadius.radius20,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language_rounded, color: AppColors.cyan, size: 16.r),
            AppSpacing.h6,
            Text(
              nameFor(context, current),
              style: TextStyle(
                fontSize: AppTextSizes.caption,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.textWhite,
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }
}
