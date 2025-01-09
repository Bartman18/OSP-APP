enum ApiResponseStatus { success, failure, unknown }

class ApiResponse {
  final ApiResponseStatus status;
  final int statusCode;
  final int errorCode;
  final dynamic content;

  factory ApiResponse({required ApiResponseStatus success, required dynamic content, int statusCode = 200, int errorCode = 0}) {
    return ApiResponse._internal(success, content, statusCode, errorCode);
  }

  factory ApiResponse.success({required dynamic content}) {
    return ApiResponse._internal(ApiResponseStatus.success, content, 200, 0);
  }

  factory ApiResponse.failure({required dynamic content, int statusCode = 500, int errorCode = 0}) {
    return ApiResponse._internal(ApiResponseStatus.failure, content, statusCode, errorCode);
  }

  factory ApiResponse.unknown({required dynamic content, int statusCode = 500, int errorCode = 0}) {
    return ApiResponse._internal(ApiResponseStatus.unknown, content, statusCode, errorCode);
  }

  ApiResponse._internal(this.status, this.content, this.statusCode, this.errorCode);

}
