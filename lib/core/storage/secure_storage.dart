import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Persisted session (token + user/business snapshots) in secure storage.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _read(AppConstants.keyAuthToken);
  Future<String?> readRefreshToken() => _read(AppConstants.keyRefreshToken);
  Future<String?> readUserData() => _read(AppConstants.keyUserData);
  Future<String?> readBusinessData() => _read(AppConstants.keyBusinessData);

  Future<void> saveSession({
    required String token,
    required String userJson,
    String? businessJson,
    String? refreshToken,
  }) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
    await _storage.write(key: AppConstants.keyUserData, value: userJson);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(
        key: AppConstants.keyRefreshToken,
        value: refreshToken,
      );
    }
    if (businessJson == null) {
      await _storage.delete(key: AppConstants.keyBusinessData);
    } else {
      await _storage.write(
        key: AppConstants.keyBusinessData,
        value: businessJson,
      );
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserData);
    await _storage.delete(key: AppConstants.keyBusinessData);
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
