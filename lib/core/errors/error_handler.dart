import 'dart:async';
import 'dart:io';
import 'app_exception.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) return error;

    if (error is SocketException || error is TimeoutException) {
      return NetworkException(originalError: error);
    }

    if (error is HttpException) {
      return ServerException(
        message: error.message,
        originalError: error,
      );
    }

    if (error is FormatException) {
      return AppException(
        'Invalid data format',
        code: 'FORMAT_ERROR',
        originalError: error,
      );
    }

    return AppException(
      error.toString(),
      code: 'UNKNOWN',
      originalError: error,
    );
  }

  static String messageFrom(dynamic error) {
    if (error is AppException) return error.message;
    return handle(error).message;
  }
}
