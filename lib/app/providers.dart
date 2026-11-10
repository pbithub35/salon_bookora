import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_executor.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../core/storage/prefs_storage.dart';
import '../core/storage/secure_storage.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/mock_auth_repository.dart';
import '../l10n/gen/app_localizations.dart';

/// Overridden in `main()` after `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

final prefsStorageProvider = Provider<PrefsStorage>(
  (ref) => PrefsStorage(ref.watch(sharedPreferencesProvider)),
);

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => ConnectivityNetworkInfo(),
);

final dioProvider = Provider<Dio>(
  (ref) => createDio(secureStorage: ref.watch(secureStorageProvider)),
);

final apiExecutorProvider = Provider<ApiExecutor>(
  (ref) => ApiExecutor(networkInfo: ref.watch(networkInfoProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(apiExecutor: ref.watch(apiExecutorProvider)),
);

// ---------------------------------------------------------------------------
// Locale
// ---------------------------------------------------------------------------

/// Riverpod `LocaleProvider`: persisted app locale (en / hi / pa).
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.read(prefsStorageProvider).selectedLocale;
    final match = AppLocalizations.supportedLocales
        .where((l) => l.languageCode == code)
        .firstOrNull;
    return match ?? const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    state = locale;
    await ref.read(prefsStorageProvider).setSelectedLocale(locale.languageCode);
  }
}

/// Localizations for the current locale, for use in viewmodels (no context).
final l10nProvider = Provider<AppLocalizations>(
  (ref) => lookupAppLocalizations(ref.watch(localeProvider)),
);
