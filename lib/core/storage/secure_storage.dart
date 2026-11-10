import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Persisted session (token + user/salon snapshots) in secure storage.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _read(AppConstants.keyAuthToken);
  Future<String?> readUserData() => _read(AppConstants.keyUserData);
  Future<String?> readSalonData() => _read(AppConstants.keySalonData);

  Future<void> saveSession({
    required String token,
    required String userJson,
    String? salonJson,
  }) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
    await _storage.write(key: AppConstants.keyUserData, value: userJson);
    if (salonJson == null) {
      await _storage.delete(key: AppConstants.keySalonData);
    } else {
      await _storage.write(key: AppConstants.keySalonData, value: salonJson);
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
    await _storage.delete(key: AppConstants.keyUserData);
    await _storage.delete(key: AppConstants.keySalonData);
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }
}
