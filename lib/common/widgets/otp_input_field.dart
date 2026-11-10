import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_text_sizes.dart';

/// 4-Digit Responsive OTP Input Field
class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  const OtpInputField({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.hasError = false,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Pasted full or partial code
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        }
      }
      final fullOtp = _currentOtp;
      widget.onChanged?.call(fullOtp);
      if (fullOtp.length == widget.length) {
        widget.onCompleted?.call(fullOtp);
      }
      return;
    }

    widget.onChanged?.call(_currentOtp);

    if (value.isNotEmpty) {
      if (index + 1 < widget.length) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        final fullOtp = _currentOtp;
        if (fullOtp.length == widget.length) {
          widget.onCompleted?.call(fullOtp);
        }
      }
    }
  }

  void _onRawKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        widget.onChanged?.call(_currentOtp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 58.w,
          height: 64.h,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onRawKey(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.inter(
                fontSize: AppTextSizes.otpDigit,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.radius16,
                  borderSide: BorderSide(
                    color: widget.hasError ? AppColors.error : AppColors.border,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.radius16,
                  borderSide: BorderSide(
                    color: widget.hasError
                        ? AppColors.error
                        : AppColors.borderFocused,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (val) => _onDigitChanged(index, val),
            ),
          ),
        );
      }),
    );
  }
}
