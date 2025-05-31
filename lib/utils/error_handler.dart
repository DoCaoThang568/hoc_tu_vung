import 'dart:io';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException([String message = 'Network connection failed']) : super(message);
}

class ServerException extends ApiException {
  ServerException([String message = 'Server error occurred']) : super(message, statusCode: 500);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized access']) : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Resource not found']) : super(message, statusCode: 404);
}

class ValidationException extends ApiException {
  ValidationException(String message, {Map<String, dynamic>? details}) 
    : super(message, statusCode: 400, details: details);
}

class ErrorHandler {
  static ApiException handleError(dynamic error) {
    if (error is SocketException) {
      return NetworkException('No internet connection');
    } else if (error is HttpException) {
      return ServerException('HTTP error: ${error.message}');
    } else if (error is FormatException) {
      return ServerException('Invalid response format');
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException('Unknown error occurred: ${error.toString()}');
    }
  }

  static String getErrorMessage(ApiException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'Không có kết nối internet. Vui lòng kiểm tra mạng.';
      case UnauthorizedException:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case NotFoundException:
        return 'Không tìm thấy dữ liệu yêu cầu.';
      case ValidationException:
        return error.message;
      case ServerException:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      default:
        return 'Đã xảy ra lỗi không xác định.';
    }
  }

  static bool shouldRetry(ApiException error) {
    return error is NetworkException || 
           error is ServerException || 
           (error.statusCode != null && error.statusCode! >= 500);
  }
}
