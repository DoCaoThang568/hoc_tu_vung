class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int statusCode;
  final Map<String, dynamic>? error;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
    this.error,
  });

  factory ApiResponse.success(T data, {String message = 'Success', int statusCode = 200}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    int statusCode = 500,
    Map<String, dynamic>? error,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      success: json['status'] == 'success' || json['success'] == true,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] ?? 'Success',
      statusCode: json['statusCode'] ?? 200,
      error: json['error'],
    );
  }
}

class LoadingState<T> {
  final bool isLoading;
  final T? data;
  final String? error;
  final bool hasData;

  LoadingState({
    this.isLoading = false,
    this.data,
    this.error,
  }) : hasData = data != null;

  LoadingState<T> copyWith({
    bool? isLoading,
    T? data,
    String? error,
  }) {
    return LoadingState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  // Helper methods
  LoadingState<T> loading() => copyWith(isLoading: true, error: null);
  LoadingState<T> success(T data) => copyWith(isLoading: false, data: data, error: null);
  LoadingState<T> failure(String error) => copyWith(isLoading: false, error: error);
}
