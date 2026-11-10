import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../network/app_error_codes.dart';

/// Root messenger key wired into `MaterialApp.router`, so feedback can be shown
/// from viewmodels without a BuildContext.
final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Thin SnackBar helper so viewmodels stay consistent.
class UiFeedback {
  UiFeedback._();

  static void error(String title, String message) => _show(title, message);

  static void info(String title, String message) => _show(title, message);

  /// Shows a failure using localized, error-code based titles/messages.
  static void failure(
    AppLocalizations l10n,
    String message, {
    String? code,
    String? fallbackTitle,
  }) {
    error(
      titleFor(l10n, code, fallbackTitle: fallbackTitle),
      messageFor(l10n, code, message),
    );
  }

  static String titleFor(
    AppLocalizations l10n,
    String? code, {
    String? fallbackTitle,
  }) {
    return switch (code) {
      AppErrorCodes.noInternet => l10n.errNoInternetTitle,
      AppErrorCodes.timeout => l10n.errTimeoutTitle,
      AppErrorCodes.network => l10n.errNetworkTitle,
      AppErrorCodes.server => l10n.errServerTitle,
      AppErrorCodes.unauthorized => l10n.errSessionExpiredTitle,
      AppErrorCodes.accountNotFound => l10n.errAccountNotFoundTitle,
      AppErrorCodes.invalidOtp => l10n.errInvalidOtpTitle,
      AppErrorCodes.notFound => l10n.errNotFoundTitle,
      _ => fallbackTitle ?? l10n.errGenericTitle,
    };
  }

  static String messageFor(
    AppLocalizations l10n,
    String? code,
    String fallback,
  ) {
    return switch (code) {
      AppErrorCodes.noInternet => l10n.errNoInternetMessage,
      AppErrorCodes.timeout => l10n.errTimeoutMessage,
      AppErrorCodes.network => l10n.errNetworkMessage,
      AppErrorCodes.server => l10n.errServerMessage,
      AppErrorCodes.unauthorized => l10n.errSessionExpiredMessage,
      AppErrorCodes.accountNotFound => l10n.errAccountNotFoundMessage,
      AppErrorCodes.notFound => l10n.errNotFoundMessage,
      _ => fallback,
    };
  }

  static void _show(String title, String message) {
    final messenger = rootMessengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(message),
            ],
          ),
        ),
      );
  }
}
