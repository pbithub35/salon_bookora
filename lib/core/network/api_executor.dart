import 'dart:async';

import 'package:dio/dio.dart';

import '../utils/app_result.dart';
import 'app_error_codes.dart';
import 'network_info.dart';

/// Runs every API/repository call through a common gate:
/// 1) connectivity check
/// 2) timeout / Dio / unexpected mapping → [AppFailure]
class ApiExecutor {
  ApiExecutor({
    required NetworkInfo networkInfo,
    this.requestTimeout = const Duration(seconds: 30),
  }) : _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;
  final Duration requestTimeout;

  Future<AppResult<T>> guard<T>(Future<AppResult<T>> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return const AppFailure(
        AppErrorMessages.noInternet,
        code: AppErrorCodes.noInternet,
      );
    }

    try {
      return await action().timeout(requestTimeout);
    } on TimeoutException {
      return const AppFailure(
        AppErrorMessages.timeout,
        code: AppErrorCodes.timeout,
      );
    } on DioException catch (e) {
      return _fromDio<T>(e);
    } catch (_) {
      return const AppFailure(
        AppErrorMessages.unexpected,
        code: AppErrorCodes.unexpected,
      );
    }
  }

  Future<AppResult<T>> run<T>(Future<T> Function() request) {
    return guard(() async {
      final data = await request();
      return AppSuccess(data);
    });
  }

  static AppFailure<T> _fromDio<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppFailure(
          AppErrorMessages.timeout,
          code: AppErrorCodes.timeout,
        );
      case DioExceptionType.connectionError:
        return const AppFailure(
          AppErrorMessages.network,
          code: AppErrorCodes.network,
        );
      case DioExceptionType.badResponse:
        return fromApiResponse<T>(e.response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return const AppFailure(
          AppErrorMessages.unexpected,
          code: AppErrorCodes.unexpected,
        );
    }
  }

  /// Prefers API envelope `{ message, error: { code } }` when present.
  static AppFailure<T> fromApiResponse<T>(Response<dynamic>? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String? message;
    String? code;
    if (data is Map) {
      message = data['message']?.toString();
      final error = data['error'];
      if (error is Map) {
        code = error['code']?.toString();
      }
    }

    if (code != null && code.isNotEmpty) {
      return AppFailure(
        message?.isNotEmpty == true ? message! : AppErrorMessages.unexpected,
        code: code,
      );
    }

    return fromStatusCode<T>(statusCode, body: message);
  }

  static AppFailure<T> fromStatusCode<T>(int statusCode, {String? body}) {
    if (statusCode == 401) {
      return AppFailure(
        body ?? AppErrorMessages.unauthorized,
        code: AppErrorCodes.unauthorized,
      );
    }
    if (statusCode == 403) {
      return AppFailure(
        body ?? 'Insufficient permissions',
        code: AppErrorCodes.forbidden,
      );
    }
    if (statusCode == 404) {
      return AppFailure(
        body ?? 'Requested resource was not found.',
        code: AppErrorCodes.notFound,
      );
    }
    if (statusCode == 429) {
      return AppFailure(
        body ?? 'Too many requests. Please try again later.',
        code: AppErrorCodes.otpRateLimited,
      );
    }
    if (statusCode >= 500) {
      return AppFailure(
        body ?? AppErrorMessages.server,
        code: AppErrorCodes.server,
      );
    }
    return AppFailure(
      body?.isNotEmpty == true ? body! : AppErrorMessages.unexpected,
      code: AppErrorCodes.unexpected,
    );
  }
}
