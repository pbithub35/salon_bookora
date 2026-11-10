import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/aurora_background.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../viewmodels/salon_owner_register_viewmodel.dart';

class SalonOwnerRegisterView extends ConsumerStatefulWidget {
  const SalonOwnerRegisterView({super.key});

  @override
  ConsumerState<SalonOwnerRegisterView> createState() =>
      _SalonOwnerRegisterViewState();
}

class _SalonOwnerRegisterViewState
    extends ConsumerState<SalonOwnerRegisterView> {
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  // Step 1: Owner Profile Details
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();

  // Step 2: Salon Business Profile Details
  final TextEditingController _salonNameController = TextEditingController();
  final TextEditingController _salonContactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController(
    text: 'Punjab',
  );
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _salonEmailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  SalonOwnerRegisterViewModel get _vm =>
      ref.read(salonOwnerRegisterViewModelProvider.notifier);

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _salonNameController.dispose();
    _salonContactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _salonEmailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (!_step1FormKey.currentState!.validate()) return;
    if (_salonContactController.text.isEmpty) {
      _salonContactController.text = _ownerPhoneController.text;
    }
    _vm.goToStep2();
  }

  Future<void> _submit() async {
    if (!_step2FormKey.currentState!.validate()) return;
    final args = await _vm.submit(
      ownerFullName: _ownerNameController.text.trim(),
      ownerMobile: _ownerPhoneController.text.trim(),
      ownerEmail: _ownerEmailController.text.trim(),
      salonName: _salonNameController.text.trim(),
      salonContact: _salonContactController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      stateName: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      salonEmail: _salonEmailController.text.trim(),
      description: _descriptionController.text.trim(),
    );
    if (args != null && mounted) context.push(AppRoutes.otp, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(salonOwnerRegisterViewModelProvider);

    return AuroraBackground(
      showBackButton: true,
      onBack: () {
        if (state.currentStep == 2) {
          _vm.goToStep1();
        } else {
          context.pop();
        }
      },
      headerHeight: 220.h,
      headerContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.auroraHeader(l10n.ownerRegisterTitle),
          AppSpacing.v10,

          // Stepper Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: AppRadius.radius20,
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepIndicator(
                  stepNum: 1,
                  title: l10n.stepOwner,
                  isActive: state.currentStep == 1,
                  isCompleted: state.currentStep > 1,
                ),
                Container(
                  width: 24.w,
                  height: 2.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  color: state.currentStep == 2
                      ? AppColors.cyan
                      : Colors.white24,
                ),
                _buildStepIndicator(
                  stepNum: 2,
                  title: l10n.stepSalon,
                  isActive: state.currentStep == 2,
                  isCompleted: false,
                ),
              ],
            ),
          ),
        ],
      ),
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: state.currentStep == 1
              ? _buildStep1OwnerForm()
              : _buildStep2SalonForm(),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNum,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Container(
          width: 22.r,
          height: 22.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.cyan
                : (isActive ? AppColors.primaryPurple : Colors.white24),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 14.r, color: AppColors.navy)
                : Text(
                    '$stepNum',
                    style: TextStyle(
                      fontSize: AppTextSizes.tiny,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        AppSpacing.h6,
        Text(
          title,
          style: TextStyle(
            fontSize: AppTextSizes.caption,
            fontWeight: isActive || isCompleted
                ? FontWeight.w700
                : FontWeight.w400,
            color: isActive || isCompleted ? Colors.white : Colors.white60,
          ),
        ),
      ],
    );
  }

  // STEP 1: Owner Details Form
  Widget _buildStep1OwnerForm() {
    final l10n = context.l10n;
    final state = ref.watch(salonOwnerRegisterViewModelProvider);
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(
            l10n.step1OwnerProfileTitle,
            fontSize: AppTextSizes.titleLarge,
          ),
          AppSpacing.v6,
          AppText.body(
            l10n.step1OwnerProfileSubtitle,
            color: AppColors.textSecondary,
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
          AppSpacing.v32,

          // Next to Step 2 Button
          AppButton.primary(
            text: l10n.nextSalonDetails,
            onPressed: _goToStep2,
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ),
          AppSpacing.v16,
        ],
      ),
    );
  }

  // STEP 2: Salon Details Form
  Widget _buildStep2SalonForm() {
    final l10n = context.l10n;
    final state = ref.watch(salonOwnerRegisterViewModelProvider);
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title(
                      l10n.step2SalonDetailsTitle,
                      fontSize: AppTextSizes.titleLarge,
                    ),
                    AppSpacing.v4,
                    AppText.body(
                      l10n.step2SalonDetailsSubtitle,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _vm.goToStep1,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 16.r,
                  color: AppColors.primaryPurple,
                ),
                label: Text(
                  l10n.editStep1,
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v20,

          // Salon Name
          AppTextField(
            label: '${l10n.salonName} *',
            hintText: l10n.hintSalonName,
            controller: _salonNameController,
            validator: (val) =>
                Validators.validateRequired(l10n, val, l10n.salonName),
            prefixIcon: const Icon(
              Icons.storefront_rounded,
              color: AppColors.primaryPurple,
            ),
          ),
          AppSpacing.v16,

          // Salon Type Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '${l10n.salonType} *',
                fontSize: AppTextSizes.inputLabel,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              AppSpacing.v6,
              DropdownButtonFormField<String>(
                initialValue: state.salonType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radius12,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radius12,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radius12,
                    borderSide: const BorderSide(
                      color: AppColors.borderFocused,
                      width: 1.8,
                    ),
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: AppTextSizes.inputText,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                items: AppConstants.salonTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) _vm.setSalonType(val);
                },
              ),
            ],
          ),
          AppSpacing.v16,

          // Salon Contact Number
          AppTextField(
            label: '${l10n.salonContact} *',
            hintText: l10n.hintSalonContact,
            controller: _salonContactController,
            validator: (v) => Validators.validateMobile(l10n, v),
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primaryPurple,
            ),
          ),
          AppSpacing.v16,

          // Address
          AppTextField(
            label: '${l10n.salonAddress} *',
            hintText: l10n.hintAddress,
            controller: _addressController,
            validator: (val) =>
                Validators.validateRequired(l10n, val, l10n.salonAddress),
            prefixIcon: const Icon(
              Icons.map_rounded,
              color: AppColors.primaryPurple,
            ),
          ),
          AppSpacing.v16,

          // City & State Row
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: '${l10n.city} *',
                  hintText: l10n.hintSalonCity,
                  controller: _cityController,
                  validator: (val) =>
                      Validators.validateRequired(l10n, val, l10n.city),
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: AppTextField(
                  label: '${l10n.state} *',
                  hintText: l10n.hintSalonState,
                  controller: _stateController,
                  validator: (val) =>
                      Validators.validateRequired(l10n, val, l10n.state),
                ),
              ),
            ],
          ),
          AppSpacing.v16,

          // Pincode
          AppTextField(
            label: '${l10n.pincode} *',
            hintText: '160071',
            controller: _pincodeController,
            validator: (v) => Validators.validatePincode(l10n, v),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          AppSpacing.v16,

          // Optional Salon Email
          AppTextField(
            label: l10n.salonEmail,
            hintText: l10n.hintSalonEmail,
            controller: _salonEmailController,
            validator: (v) => Validators.validateEmail(l10n, v),
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.v16,

          // Optional Description
          AppTextField(
            label: l10n.salonDescription,
            hintText: l10n.hintSalonDescription,
            controller: _descriptionController,
            maxLines: 3,
          ),
          AppSpacing.v32,

          // Submit Application Button
          AppButton.primary(
            text: l10n.submitApplication,
            isLoading: state.isLoading,
            onPressed: _submit,
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
          ),
          AppSpacing.v16,
        ],
      ),
    );
  }
}
