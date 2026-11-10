import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Non-sensitive preferences only (onboarding flag, locale). Tokens live in
/// [SecureStorage].
class PrefsStorage {
  PrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  bool get hasSeenOnboarding =>
      _prefs.getBool(AppConstants.keyHasSeenOnboarding) ?? false;

  Future<void> setHasSeenOnboarding(bool value) =>
      _prefs.setBool(AppConstants.keyHasSeenOnboarding, value);

  String? get selectedLocale =>
      _prefs.getString(AppConstants.keySelectedLocale);

  Future<void> setSelectedLocale(String code) =>
      _prefs.setString(AppConstants.keySelectedLocale, code);
}
