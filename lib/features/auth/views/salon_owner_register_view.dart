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
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../viewmodels/salon_owner_register_viewmodel.dart';

/// Owner registration = business account only (name, mobile, email, optional
/// brand). No salon/shop is created here — the owner adds shops from the
/// dashboard after OTP verification.
class SalonOwnerRegisterView extends ConsumerStatefulWidget {
  const SalonOwnerRegisterView({super.key});

  @override
  ConsumerState<SalonOwnerRegisterView> createState() =>
      _SalonOwnerRegisterViewState();
}

class _SalonOwnerRegisterViewState
    extends ConsumerState<SalonOwnerRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();

  SalonOwnerRegisterViewModel get _vm =>
      ref.read(salonOwnerRegisterViewModelProvider.notifier);

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _brandNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final args = await _vm.submit(
      ownerFullName: _ownerNameController.text.trim(),
      ownerMobile: _ownerPhoneController.text.trim(),
      ownerEmail: _ownerEmailController.text.trim(),
      brandName: _brandNameController.text.trim(),
    );
    if (args != null && mounted) context.push(AppRoutes.otp, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(salonOwnerRegisterViewModelProvider);

    return AuroraBackground(
      showBackButton: true,
      onBack: () => context.pop(),
      headerHeight: 200.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.auroraHeader(l10n.ownerRegisterTitle),
          AppSpacing.v10,
          Text(
            l10n.ownerRegisterFormSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
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
                  l10n.ownerRegisterFormTitle,
                  fontSize: AppTextSizes.titleLarge,
                ),
                AppSpacing.v20,

                // Owner Full Name
                AppTextField(
                  label: l10n.ownerFullNameLabel,
                  hintText: l10n.hintOwnerName,
                  controller: _ownerNameController,
                  validator: (v) => Validators.validateFullName(l10n, v),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v16,

                // Owner Mobile Number
                PhoneNumberField(
                  controller: _ownerPhoneController,
                  selectedCountryCode: state.countryCode,
                  onCountryChanged: _vm.setCountryCode,
                  label: l10n.ownerMobileLabel,
                ),
                AppSpacing.v16,

                // Owner Email Address
                AppTextField(
                  label: l10n.ownerEmailLabel,
                  hintText: l10n.hintOwnerEmail,
                  controller: _ownerEmailController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.validationOwnerEmailRequired;
                    }
                    return Validators.validateEmail(l10n, val);
                  },
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v16,

                // Optional Brand Name
                AppTextField(
                  label: l10n.brandNameLabel,
                  hintText: l10n.hintBrandName,
                  controller: _brandNameController,
                  prefixIcon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.primaryPurple,
                  ),
                ),
                AppSpacing.v32,

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
