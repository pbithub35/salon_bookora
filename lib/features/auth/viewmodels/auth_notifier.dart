import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/app_result.dart';
import '../../../core/utils/auth_destination.dart';
import '../../../data/models/salon_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// Immutable session snapshot.
class AuthState {
  const AuthState({this.user, this.salon});

  final UserModel? user;
  final SalonModel? salon;

  bool get isLoggedIn => user != null;

  String get destinationRoute =>
      AuthDestination.resolve(user: user, salon: salon);
}

/// Loads a persisted session from secure storage (called once in `main()`).
Future<AuthState> restoreAuthState(SecureStorage storage) async {
  final token = await storage.readToken();
  final userJson = await storage.readUserData();
  if (token == null || userJson == null) return const AuthState();

  try {
    final salonJson = await storage.readSalonData();
    return AuthState(
      user: UserModel.fromJson(userJson),
      salon: salonJson == null ? null : SalonModel.fromJson(salonJson),
    );
  } catch (_) {
    await storage.clearSession();
    return const AuthState();
  }
}

/// Overridden in `main()` with the restored session.
final initialAuthStateProvider = Provider<AuthState>(
  (ref) => const AuthState(),
);

/// Session orchestrator: holds auth state, delegates to [AuthRepository].
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() => ref.read(initialAuthStateProvider);

  Future<AppResult<Empty>> sendOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
  }) {
    return _repo.sendOtp(
      countryCode: countryCode,
      mobileNumber: mobileNumber,
      purpose: purpose,
    );
  }

  Future<AppResult<Empty>> verifyOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
    required String otp,
  }) {
    return _repo.verifyOtp(
      countryCode: countryCode,
      mobileNumber: mobileNumber,
      purpose: purpose,
      otp: otp,
    );
  }

  Future<AppResult<Empty>> completeLogin({
    required String countryCode,
    required String mobileNumber,
  }) async {
    final result = await _repo.loginWithMobile(
      countryCode: countryCode,
      mobileNumber: mobileNumber,
    );
    return _apply(result);
  }

  Future<AppResult<Empty>> registerCustomer({
    required String fullName,
    required String countryCode,
    required String mobileNumber,
    String? email,
    String? city,
  }) async {
    final result = await _repo.registerCustomer(
      fullName: fullName,
      countryCode: countryCode,
      mobileNumber: mobileNumber,
      email: email,
      city: city,
    );
    return _apply(result);
  }

  Future<AppResult<Empty>> registerSalonOwner({
    required String ownerFullName,
    required String countryCode,
    required String ownerMobile,
    String? ownerEmail,
    required String salonName,
    required String salonType,
    required String salonContact,
    required String address,
    required String city,
    required String state,
    required String pincode,
    String? salonEmail,
    String? description,
  }) async {
    final result = await _repo.registerSalonOwner(
      ownerFullName: ownerFullName,
      countryCode: countryCode,
      ownerMobile: ownerMobile,
      ownerEmail: ownerEmail,
      salonName: salonName,
      salonType: salonType,
      salonContact: salonContact,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      salonEmail: salonEmail,
      description: description,
    );
    return _apply(result);
  }

  Future<AppResult<Empty>> _apply(AppResult<AuthSessionData> result) async {
    return switch (result) {
      AppSuccess<AuthSessionData>(:final data) => await _applySession(data),
      AppFailure<AuthSessionData>(:final message, :final code) => AppFailure(
        message,
        code: code,
      ),
    };
  }

  Future<AppResult<Empty>> _applySession(AuthSessionData session) async {
    await ref
        .read(secureStorageProvider)
        .saveSession(
          token: session.token,
          userJson: session.user.toJson(),
          salonJson: session.salon?.toJson(),
        );
    state = AuthState(user: session.user, salon: session.salon);
    return const AppSuccess(empty);
  }

  String getDestinationRoute() =>
      state.isLoggedIn ? state.destinationRoute : AppRoutes.welcome;

  /// Clears the session; the router redirect sends the user to Welcome.
  Future<void> logout() async {
    state = const AuthState();
    await ref.read(secureStorageProvider).clearSession();
  }
}
