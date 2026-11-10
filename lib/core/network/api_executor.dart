import 'dart:async';

import 'package:dio/dio.dart';

import '../utils/app_result.dart';
import 'app_error_codes.dart';
import 'network_info.dart';

/// Runs every API/repository call through a common gate:
/// 1) connectivity check
/// 2) timeout / socket / HTTP exception mapping → [AppFailure]
class ApiExecutor {
  ApiExecutor({
    required NetworkInfo networkInfo,
    this.requestTimeout = const Duration(seconds: 30),
  }) : _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;
  final Duration requestTimeout;

  /// Prefer this for repository methods that already return [AppResult].
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

  /// Prefer this for raw remote calls that return data / throw.
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
        return fromStatusCode<T>(e.response?.statusCode ?? 0);
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

  /// Maps common HTTP status codes into [AppFailure].
  static AppFailure<T> fromStatusCode<T>(int statusCode, {String? body}) {
    if (statusCode == 401 || statusCode == 403) {
      return const AppFailure(
        AppErrorMessages.unauthorized,
        code: AppErrorCodes.unauthorized,
      );
    }
    if (statusCode == 404) {
      return const AppFailure(
        'Requested resource was not found.',
        code: AppErrorCodes.notFound,
      );
    }
    if (statusCode >= 500) {
      return const AppFailure(
        AppErrorMessages.server,
        code: AppErrorCodes.server,
      );
    }
    return AppFailure(
      body?.isNotEmpty == true ? body! : AppErrorMessages.unexpected,
      code: AppErrorCodes.unexpected,
    );
  }
}
