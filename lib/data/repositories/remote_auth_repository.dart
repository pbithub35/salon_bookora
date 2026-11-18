import 'package:dio/dio.dart';

import '../../core/network/api_executor.dart';
import '../../core/network/app_error_codes.dart';
import '../../core/utils/app_result.dart';
import '../models/business_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Live auth repository talking to SalonBookora Express API (`/api/v1/auth`).
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({
    required ApiExecutor apiExecutor,
    required Dio dio,
  }) : _api = apiExecutor,
       _dio = dio;

  final ApiExecutor _api;
  final Dio _dio;

  @override
  Future<AppResult<Empty>> sendOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
  }) {
    return _api.guard(() async {
      await _dio.post<Map<String, dynamic>>(
        '/auth/otp/send',
        data: {
          'countryCode': countryCode,
          'mobileNumber': mobileNumber,
          'purpose': purpose.name,
        },
      );
      return const AppSuccess(empty);
    });
  }

  @override
  Future<AppResult<Empty>> verifyOtp({
    required String countryCode,
    required String mobileNumber,
    required AuthPurpose purpose,
    required String otp,
  }) {
    return _api.guard(() async {
      await _dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {
          'countryCode': countryCode,
          'mobileNumber': mobileNumber,
          'purpose': purpose.name,
          'otp': otp,
        },
      );
      return const AppSuccess(empty);
    });
  }

  @override
  Future<AppResult<AuthSessionData>> loginWithMobile({
    required String countryCode,
    required String mobileNumber,
  }) {
    return _api.guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'countryCode': countryCode,
          'mobileNumber': mobileNumber,
        },
      );
      return AppSuccess(_sessionFrom(response.data));
    });
  }

  @override
  Future<AppResult<AuthSessionData>> registerCustomer({
    required String fullName,
    required String countryCode,
    required String mobileNumber,
    String? email,
    String? city,
  }) {
    return _api.guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register/customer',
        data: {
          'fullName': fullName,
          'countryCode': countryCode,
          'mobileNumber': mobileNumber,
          'email': ?email,
          'city': ?city,
        },
      );
      return AppSuccess(_sessionFrom(response.data));
    });
  }

  @override
  Future<AppResult<AuthSessionData>> registerSalonOwner({
    required String ownerFullName,
    required String countryCode,
    required String ownerMobile,
    String? ownerEmail,
    String? brandName,
  }) {
    return _api.guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register/salon-owner',
        data: {
          'ownerFullName': ownerFullName,
          'countryCode': countryCode,
          'ownerMobile': ownerMobile,
          'mobileNumber': ownerMobile,
          'ownerEmail': ?ownerEmail,
          'brandName': ?brandName,
        },
      );
      return AppSuccess(_sessionFrom(response.data));
    });
  }

  AuthSessionData _sessionFrom(Map<String, dynamic>? body) {
    final data = (body?['data'] as Map<String, dynamic>?) ?? body ?? const {};
    final userMap = data['user'] as Map<String, dynamic>?;
    if (userMap == null) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: AppErrorMessages.unexpected,
      );
    }
    final businessMap = data['business'] as Map<String, dynamic>?;
    return AuthSessionData(
      token: data['token'] as String? ?? '',
      refreshToken: data['refreshToken'] as String?,
      user: UserModel.fromMap(userMap),
      business: businessMap == null
          ? null
          : BusinessModel.fromMap(businessMap),
    );
  }
}
