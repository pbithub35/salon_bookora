import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../common/widgets/seed_accounts_card.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vm = ref.read(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

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
            child: Icon(
              Icons.phone_android_rounded,
              color: AppColors.cyan,
              size: 28.r,
            ),
          ),
          AppSpacing.v10,
          AppText.auroraHeader(l10n.loginTitle),
          AppSpacing.v4,
          AppText.auroraSubtitle(l10n.loginSubtitle),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText.title(
                  l10n.loginEnterPhoneTitle,
                  fontSize: AppTextSizes.titleLarge,
                ),
                AppSpacing.v6,
                AppText.body(
                  l10n.loginEnterPhoneSubtitle,
                  color: AppColors.textSecondary,
                ),
                AppSpacing.v24,

                // Phone Input Field
                PhoneNumberField(
                  controller: _phoneController,
                  selectedCountryCode: state.countryCode,
                  onCountryChanged: vm.setCountryCode,
                  label: l10n.mobileNumber,
                ),
                AppSpacing.v20,

                // Quick Seed Test Accounts (Phase 1 Testing Helper)
                SeedAccountsCard(
                  onSelected: (number) => _phoneController.text = number,
                ),
                AppSpacing.v32,

                // Request OTP Button
                AppButton.primary(
                  text: l10n.requestOtp,
                  isLoading: state.isLoading,
                  onPressed: _requestOtp,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
                AppSpacing.v24,

                // Don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: TextStyle(
                        fontSize: AppTextSizes.bodySmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push(AppRoutes.roleSelect),
                      child: Text(
                        l10n.registerNow,
                        style: TextStyle(
                          fontSize: AppTextSizes.bodySmall,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
