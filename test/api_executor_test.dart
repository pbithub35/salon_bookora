import 'package:flutter_test/flutter_test.dart';
import 'package:salon_bookora/core/network/api_executor.dart';
import 'package:salon_bookora/core/network/app_error_codes.dart';
import 'package:salon_bookora/core/network/network_info.dart';
import 'package:salon_bookora/core/utils/app_result.dart';

void main() {
  group('ApiExecutor', () {
    test('returns NO_INTERNET when offline', () async {
      final executor = ApiExecutor(
        networkInfo: FakeNetworkInfo(connected: false),
      );

      final result = await executor.guard(
        () async => const AppSuccess(empty),
      );

      expect(result.isFailure, isTrue);
      expect(result.codeOrNull, AppErrorCodes.noInternet);
      expect(result.errorOrNull, AppErrorMessages.noInternet);
    });

    test('runs action when online', () async {
      final executor = ApiExecutor(
        networkInfo: FakeNetworkInfo(connected: true),
      );

      final result = await executor.guard(
        () async => const AppSuccess(empty),
      );

      expect(result.isSuccess, isTrue);
    });

    test('maps unexpected exceptions to UNEXPECTED', () async {
      final executor = ApiExecutor(
        networkInfo: FakeNetworkInfo(connected: true),
      );

      final result = await executor.guard<Empty>(
        () async => throw StateError('boom'),
      );

      expect(result.isFailure, isTrue);
      expect(result.codeOrNull, AppErrorCodes.unexpected);
    });

    test('fromStatusCode maps 401 and 500', () {
      expect(
        ApiExecutor.fromStatusCode<void>(401).code,
        AppErrorCodes.unauthorized,
      );
      expect(
        ApiExecutor.fromStatusCode<void>(503).code,
        AppErrorCodes.server,
      );
    });
  });

}
