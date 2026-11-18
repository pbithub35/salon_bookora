/// Shared API / network error codes used across repositories & UI.
abstract final class AppErrorCodes {
  static const noInternet = 'NO_INTERNET';
  static const timeout = 'TIMEOUT';
  static const network = 'NETWORK_ERROR';
  static const server = 'SERVER_ERROR';
  static const unauthorized = 'UNAUTHORIZED';
  static const notFound = 'NOT_FOUND';
  static const accountNotFound = 'ACCOUNT_NOT_FOUND';
  static const accountExists = 'ACCOUNT_EXISTS';
  static const accountRestricted = 'ACCOUNT_RESTRICTED';
  static const invalidOtp = 'INVALID_OTP';
  static const otpRequired = 'OTP_REQUIRED';
  static const otpRateLimited = 'OTP_RATE_LIMITED';
  static const otpLocked = 'OTP_LOCKED';
  static const validationError = 'VALIDATION_ERROR';
  static const forbidden = 'FORBIDDEN';
  static const unexpected = 'UNEXPECTED';
}

abstract final class AppErrorMessages {
  static const noInternet =
      'No internet connection. Please check your network and try again.';
  static const timeout = 'Request timed out. Please try again.';
  static const network = 'Network error. Please try again.';
  static const server = 'Something went wrong on our side. Please try again.';
  static const unauthorized = 'Session expired. Please log in again.';
  static const unexpected = 'Something went wrong. Please try again.';
}
