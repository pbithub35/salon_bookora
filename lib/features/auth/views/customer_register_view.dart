import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/customer_register_viewmodel.dart';

class CustomerRegisterView extends ConsumerStatefulWidget {
  const CustomerRegisterView({super.key});

  @override
  ConsumerState<CustomerRegisterView> createState() =>
      _CustomerRegisterViewState();
}

class _CustomerRegisterViewState extends ConsumerState<CustomerRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final args = await ref
        .read(customerRegisterViewModelProvider.notifier)
        .submit(
          fullName: _nameController.text.trim(),
          mobile: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          city: _cityController.text.trim(),
        );
    if (args != null && mounted) context.push(AppRoutes.otp, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vm = ref.read(customerRegisterViewModelProvider.notifier);
    final state = ref.watch(customerRegisterViewModelProvider);

    return AuroraBackground(
      showBackButton: true,
      headerHeight: 200.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.auroraHeader(l10n.customerRegisterTitle),
          AppSpacing.v4,
          AppText.auroraSubtitle(l10n.customerRegisterSubtitle),
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
                // Full Name
                AppTextField(
                  label: l10n.fullName,
                  hintText: l10n.hintFullName,
                  controller: _nameController,
                  validator: (v) => Validators.validateFullName(l10n, v),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v16,

                // Mobile Number
                PhoneNumberField(
                  controller: _phoneController,
                  selectedCountryCode: state.countryCode,
                  onCountryChanged: vm.setCountryCode,
                  label: l10n.mobileNumber,
                ),
                AppSpacing.v16,

                // Email (Optional)
                AppTextField(
                  label: l10n.email,
                  hintText: l10n.hintEmail,
                  controller: _emailController,
                  validator: (v) => Validators.validateEmail(l10n, v),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v16,

                // City
                AppTextField(
                  label: l10n.city,
                  hintText: l10n.hintCity,
                  controller: _cityController,
                  prefixIcon: const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v20,

                // Terms agreement checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: state.agreedToTerms,
                      activeColor: AppColors.primaryPurple,
                      onChanged: vm.toggleTerms,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.agreeToTerms,
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.v28,

                // Submit Button
                AppButton.primary(
                  text: l10n.continueToOtp,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
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
