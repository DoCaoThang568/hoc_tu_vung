class ApiConfig {
  // Base URL của backend API - cần thay đổi thành URL thật
  static const String baseUrl = 'http://localhost:3000'; // Thay đổi URL này khi deploy
  
  // API Endpoints
  static const String categoriesEndpoint = '/api/categories';
  static const String authLoginEndpoint = '/api/auth/login';
  static const String authRegisterEndpoint = '/api/auth/register';
  static const String authGoogleEndpoint = '/api/auth/google-signin';
  static const String lessonsEndpoint = '/api/categories/{id}/lessons';
  static const String vocabularyEndpoint = '/api/lessons/{id}/vocabulary';
  static const String quizEndpoint = '/api/lessons/{id}/quiz';
  static const String progressEndpoint = '/api/progress';
  static const String submitQuizEndpoint = '/api/progress/quiz-submit';
  static const String userStatsEndpoint = '/api/progress/user-stats';
  static const String historyEndpoint = '/api/progress/history';
  
  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  
  // Retry configurations
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Build full URL
  static String buildUrl(String endpoint, {Map<String, String>? pathParams}) {
    String url = baseUrl + endpoint;
    
    if (pathParams != null) {
      pathParams.forEach((key, value) {
        url = url.replaceAll('{$key}', value);
      });
    }
    
    return url;
  }
  
  // Add authorization header
  static Map<String, String> getAuthHeaders(String? token) {
    final headers = Map<String, String>.from(defaultHeaders);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
