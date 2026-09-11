class AppException implements Exception {
  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  final String message;
  final String? code;
  final dynamic originalError;

  @override
  String toString() =>
      'AppException: $message${code != null ? ' ($code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

class AuthException extends AppException {
  const AuthException({
    String message = 'Authentication failed',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

class ServerException extends AppException {
  const ServerException({
    String message = 'Server error occurred',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

class CacheException extends AppException {
  const CacheException({
    String message = 'Cache error occurred',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}
