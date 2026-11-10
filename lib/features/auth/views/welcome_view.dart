import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/language_selector.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../common/widgets/seed_accounts_card.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/login_viewmodel.dart';

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({super.key});

  @override
  ConsumerState<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends ConsumerState<WelcomeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final args = await ref
        .read(loginViewModelProvider.notifier)
        .requestOtp(_phoneController.text.trim());
    if (args != null && mounted) context.push(AppRoutes.otp, extra: args);
  }

  void _showLegalDialog(BuildContext context, String title, String content) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topSheet),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: AppRadius.radius8,
                    ),
                  ),
                ),
                AppSpacing.v16,
                AppText.title(title),
                AppSpacing.v12,
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 280.h),
                  child: SingleChildScrollView(
                    child: AppText.body(
                      content,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                AppSpacing.v16,
                AppButton.primary(
                  text: l10n.close,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vm = ref.read(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

    return AuroraBackground(
      headerHeight: 220.h,
      headerAction: const LanguageSelector(),
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.cyan.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.3),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.spa_rounded, color: AppColors.cyan, size: 36.r),
            ),
          ),
          AppSpacing.v16,
          AppText.auroraHeader(l10n.welcomeTitle),
          AppSpacing.v6,
          Text(
            l10n.appTagline,
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              fontWeight: FontWeight.w600,
              color: AppColors.cyan,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.v8,
                AppText.title(
                  l10n.loginTitle,
                  fontSize: AppTextSizes.headingMedium,
                ),
                AppSpacing.v8,
                AppText.body(
                  l10n.loginSubtitle,
                  color: AppColors.textSecondary,
                ),
                AppSpacing.v24,

                PhoneNumberField(
                  controller: _phoneController,
                  selectedCountryCode: state.countryCode,
                  onCountryChanged: vm.setCountryCode,
                  label: l10n.mobileNumber,
                ),
                AppSpacing.v20,

                SeedAccountsCard(
                  onSelected: (number) => _phoneController.text = number,
                ),
                AppSpacing.v24,

                AppButton.primary(
                  text: l10n.requestOtp,
                  isLoading: state.isLoading,
                  onPressed: _requestOtp,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
                AppSpacing.v16,

                AppButton.secondary(
                  text: l10n.createAccount,
                  onPressed: () => context.push(AppRoutes.roleSelect),
                  icon: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v24,

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.termsNotice,
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          color: AppColors.textMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => _showLegalDialog(
                          context,
                          l10n.termsAndConditions,
                          l10n.termsDialogBody,
                        ),
                        child: Text(
                          l10n.termsAndConditions,
                          style: TextStyle(
                            fontSize: AppTextSizes.caption,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        l10n.and,
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          color: AppColors.textMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => _showLegalDialog(
                          context,
                          l10n.privacyPolicy,
                          l10n.privacyDialogBody,
                        ),
                        child: Text(
                          l10n.privacyPolicy,
                          style: TextStyle(
                            fontSize: AppTextSizes.caption,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.v12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
