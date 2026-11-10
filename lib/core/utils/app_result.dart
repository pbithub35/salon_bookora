/// Lightweight success/failure wrapper for service & repository calls.
sealed class AppResult<T> {
  const AppResult();

  bool get isSuccess => this is AppSuccess<T>;
  bool get isFailure => this is AppFailure<T>;

  T? get dataOrNull => switch (this) {
    AppSuccess<T>(:final data) => data,
    AppFailure<T>() => null,
  };

  String? get errorOrNull => switch (this) {
    AppSuccess<T>() => null,
    AppFailure<T>(:final message) => message,
  };

  String? get codeOrNull => switch (this) {
    AppSuccess<T>() => null,
    AppFailure<T>(:final code) => code,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) failure,
  }) {
    return switch (this) {
      AppSuccess<T>(:final data) => success(data),
      AppFailure<T>(:final message, :final code) => failure(message, code),
    };
  }
}

/// Marker for operations that succeed without a payload.
class Empty {
  const Empty();
}

const empty = Empty();

final class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.data);
  final T data;
}

final class AppFailure<T> extends AppResult<T> {
  const AppFailure(this.message, {this.code});
  final String message;
  final String? code;
}
