import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_sizes.dart';
import 'app_text.dart';

/// Professional Reusable Text Input Field for SalonBookora
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.contentPadding,
    this.fillColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
          focusNode: widget.focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: GoogleFonts.inter(
            fontSize: AppTextSizes.inputText,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: AppTextSizes.inputHint,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.surface,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: widget.maxLines > 1 ? 14.h : 14.h,
                ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 24.h,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20.r,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
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
