import '../../l10n/gen/app_localizations.dart';

/// Form and input validators for SalonBookora (localized messages).
class Validators {
  Validators._();

  static String? validateMobile(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationMobileRequired;
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10) {
      return l10n.validationMobileInvalid;
    }
    return null;
  }

  static String? validateFullName(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationFullNameRequired;
    }
    if (value.trim().length < 2) {
      return l10n.validationNameTooShort;
    }
    return null;
  }

  static String? validateEmail(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional in Phase 1
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  static String? validateRequired(
    AppLocalizations l10n,
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationFieldRequired(fieldName);
    }
    return null;
  }

  static String? validatePincode(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationPincodeRequired;
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 6) {
      return l10n.validationPincodeInvalid;
    }
    return null;
  }
}
