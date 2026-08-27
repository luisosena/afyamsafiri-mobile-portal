class ApiResponseWrapper<T> {
  const ApiResponseWrapper({
    this.data,
    this.error,
    this.statusCode,
    this.isSuccess = false,
  });

  final T? data;
  final String? error;
  final int? statusCode;
  final bool isSuccess;

  factory ApiResponseWrapper.success(T data, {int? statusCode}) {
    return ApiResponseWrapper(
      data: data,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  factory ApiResponseWrapper.failure(String error, {int? statusCode}) {
    return ApiResponseWrapper(
      error: error,
      statusCode: statusCode,
      isSuccess: false,
    );
  }
}
