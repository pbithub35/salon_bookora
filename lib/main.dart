import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/viewmodels/auth_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final secureStorage = SecureStorage();
  final initialAuth = await restoreAuthState(secureStorage);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialAuthStateProvider.overrideWithValue(initialAuth),
      ],
      child: const SalonBookoraApp(),
    ),
  );
}
