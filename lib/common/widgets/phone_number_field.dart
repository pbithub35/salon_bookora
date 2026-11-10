import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import '../../core/utils/l10n_extension.dart';
import 'app_text.dart';

/// Standardized Mobile Number Field with Country Code Picker
class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final void Function(String)? onCountryChanged;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? label;
  final bool enabled;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.selectedCountryCode = '+91',
    this.onCountryChanged,
    this.onChanged,
    this.validator,
    this.label,
    this.enabled = true,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late String _countryCode;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.selectedCountryCode;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topSheet),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                AppText.title(context.l10n.selectCountryCode),
                AppSpacing.v12,
                ...AppConstants.countryCodes.map((item) {
                  final isSelected = item['code'] == _countryCode;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      item['flag'] ?? '',
                      style: TextStyle(fontSize: 22.sp),
                    ),
                    title: AppText(
                      '${item['name']} (${item['code']})',
                      fontSize: AppTextSizes.body,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.textPrimary,
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryPurple,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _countryCode = item['code']!;
                      });
                      widget.onCountryChanged?.call(_countryCode);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppText(
            widget.label!,
            fontSize: AppTextSizes.inputLabel,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          AppSpacing.v6,
        ],
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: widget.onChanged,
          validator:
              widget.validator ??
              (val) {
                if (val == null || val.trim().isEmpty) {
                  return context.l10n.validationMobileRequired;
                }
                if (val.trim().length != 10) {
                  return context.l10n.validationMobileInvalid;
                }
                return null;
              },
          style: GoogleFonts.inter(
            fontSize: AppTextSizes.inputText,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
          decoration: InputDecoration(
            hintText: '98765 43210',
            hintStyle: GoogleFonts.inter(
              fontSize: AppTextSizes.inputHint,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              letterSpacing: 0,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            prefixIcon: InkWell(
              onTap: widget.enabled ? _showCountryPicker : null,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppRadius.r12),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.border, width: 1.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      _countryCode,
                      fontSize: AppTextSizes.inputText,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    AppSpacing.h4,
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.textSecondary,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.radius12,
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radius12,
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radius12,
              borderSide: const BorderSide(
                color: AppColors.borderFocused,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.radius12,
              borderSide: const BorderSide(color: AppColors.error, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.radius12,
              borderSide: const BorderSide(color: AppColors.error, width: 1.8),
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: AppTextSizes.errorText,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
