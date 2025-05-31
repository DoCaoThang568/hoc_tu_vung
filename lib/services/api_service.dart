import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Token cho authentication
  static String? _authToken;
  
  // Set auth token
  static void setAuthToken(String token) {
    _authToken = token;
  }
  
  // Clear auth token
  static void clearAuthToken() {
    _authToken = null;
  }
  
  // Get headers với auth token nếu có
  static Map<String, String> get _headers {
    Map<String, String> headers = Map.from(ApiConfig.defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }
  // GET request
  static Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      String url = ApiConfig.baseUrl + endpoint;
      
      // Add query parameters
      if (queryParams != null && queryParams.isNotEmpty) {
        url += '?' + queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      print('🌐 API GET: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Không có kết nối internet');
    } on HttpException {
      return ApiResponse.error('Lỗi kết nối server');
    } catch (e) {
      print('❌ API Error: $e');
      return ApiResponse.error('Đã có lỗi xảy ra: $e');
    }
  }
  // POST request
  static Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      String url = ApiConfig.baseUrl + endpoint;
      print('🌐 API POST: $url');
      print('📤 Data: $data');

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Không có kết nối internet');
    } on HttpException {
      return ApiResponse.error('Lỗi kết nối server');
    } catch (e) {
      print('❌ API Error: $e');
      return ApiResponse.error('Đã có lỗi xảy ra: $e');
    }
  }
  // PUT request
  static Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      String url = ApiConfig.baseUrl + endpoint;
      print('🌐 API PUT: $url');

      final response = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Không có kết nối internet');
    } on HttpException {
      return ApiResponse.error('Lỗi kết nối server');
    } catch (e) {
      print('❌ API Error: $e');
      return ApiResponse.error('Đã có lỗi xảy ra: $e');
    }
  }
  // DELETE request
  static Future<ApiResponse> delete(String endpoint) async {
    try {
      String url = ApiConfig.baseUrl + endpoint;
      print('🌐 API DELETE: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Không có kết nối internet');
    } on HttpException {
      return ApiResponse.error('Lỗi kết nối server');
    } catch (e) {
      print('❌ API Error: $e');
      return ApiResponse.error('Đã có lỗi xảy ra: $e');
    }
  }  // Handle HTTP response
  static ApiResponse _handleResponse(http.Response response) {
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return ApiResponse.success(jsonData);
      } catch (e) {
        return ApiResponse.error('Lỗi parse dữ liệu từ server');
      }
    } else if (response.statusCode == 401) {
      // Unauthorized - clear token
      clearAuthToken();
      return ApiResponse.error('Phiên đăng nhập đã hết hạn');
    } else if (response.statusCode == 404) {
      return ApiResponse.error('Không tìm thấy dữ liệu');
    } else if (response.statusCode >= 500) {
      return ApiResponse.error('Lỗi server, vui lòng thử lại sau');
    } else {
      try {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Đã có lỗi xảy ra';
        return ApiResponse.error(errorMessage);
      } catch (e) {
        return ApiResponse.error('Đã có lỗi xảy ra (${response.statusCode})');
      }
    }
  }
}

// API Response wrapper class với generic type support
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  ApiResponse.success(this.data)
      : isSuccess = true,
        error = null;

  ApiResponse.error(this.error)
      : isSuccess = false,
        data = null;
}

// Backward compatibility wrapper
class ApiResponseMap extends ApiResponse<Map<String, dynamic>> {
  ApiResponseMap.success(Map<String, dynamic>? data) : super.success(data);
  ApiResponseMap.error(String? error) : super.error(error);
}
