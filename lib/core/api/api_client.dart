import 'package:dio/dio.dart';
import 'endpoints.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {

    final defaultUrl = baseUrl ?? ApiEndpoints.baseUrl;
    print('═══════════════════════════════════════════════════════════');
    print('[API CLIENT] Initializing with URL: $defaultUrl');
    print('═══════════════════════════════════════════════════════════');
    
    _dio = Dio(
      BaseOptions(
        baseUrl: defaultUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          print('───────────────────────────────────────────────────────────');
          print('[API REQUEST] ${options.method} ${options.baseUrl}${options.path}');
          print('[API REQUEST] Full URL: ${options.baseUrl}${options.path}');
          print('[API REQUEST] Timeout: ${options.connectTimeout}');
          print('───────────────────────────────────────────────────────────');
          return handler.next(options);
        },
        onError: (error, handler) {
          print('───────────────────────────────────────────────────────────');
          print('[API ERROR] Type: ${error.type}');
          print('[API ERROR] Message: ${error.message}');
          print('[API ERROR] Response: ${error.response?.statusCode}');
          print('[API ERROR] Error: ${error.error}');
          print('───────────────────────────────────────────────────────────');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
    int retries = 2,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        print('[API] GET $path (attempt ${attempt + 1}/${retries + 1})');
        final response = await _dio.get<dynamic>(
          path,
          queryParameters: queryParameters,
        );
        print('[API Success] GET $path - Status: ${response.statusCode}');
        return fromJson(response.data);
      } on DioException catch (e) {
        // If it's the last attempt or not a connection error, throw immediately
        if (attempt == retries || 
            (e.type != DioExceptionType.connectionTimeout && 
             e.type != DioExceptionType.connectionError &&
             e.type != DioExceptionType.unknown)) {
          final error = _handleError(e);
          print('[API Failed] GET $path: $error');
          throw error;
        }
        
        // Wait before retry (exponential backoff)
        final waitTime = Duration(seconds: (attempt + 1) * 2);
        print('[API Retry] GET $path failed, retrying in ${waitTime.inSeconds}s...');
        await Future.delayed(waitTime);
      }
    }
    
    // This should never be reached, but just in case
    throw Exception('Max retries exceeded');
  }

  Future<T> patch<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(dynamic) fromJson,
    int retries = 2,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        print('[API] PATCH $path (attempt ${attempt + 1}/${retries + 1})');
        final response = await _dio.patch<dynamic>(
          path,
          data: data,
        );
        print('[API Success] PATCH $path - Status: ${response.statusCode}');
        return fromJson(response.data);
      } on DioException catch (e) {
        // If it's the last attempt or not a connection error, throw immediately
        if (attempt == retries || 
            (e.type != DioExceptionType.connectionTimeout && 
             e.type != DioExceptionType.connectionError &&
             e.type != DioExceptionType.unknown)) {
          final error = _handleError(e);
          print('[API Failed] PATCH $path: $error');
          throw error;
        }
        
        // Wait before retry (exponential backoff)
        final waitTime = Duration(seconds: (attempt + 1) * 2);
        print('[API Retry] PATCH $path failed, retrying in ${waitTime.inSeconds}s...');
        await Future.delayed(waitTime);
      }
    }
    
    // This should never be reached, but just in case
    throw Exception('Max retries exceeded');
  }

  String _handleError(DioException error) {
    print('═══════════════════════════════════════════════════════════');
    print('[ERROR HANDLER] DioException Type: ${error.type}');
    print('[ERROR HANDLER] Message: ${error.message}');
    print('[ERROR HANDLER] Error Object: ${error.error}');
    print('[ERROR HANDLER] Response Status: ${error.response?.statusCode}');
    print('═══════════════════════════════════════════════════════════');
    
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data is Map
          ? error.response!.data['message'] ?? 'Unknown error'
          : error.message ?? 'Unknown error';
      return 'Error $statusCode: $message';
    }
    
    // Connection errors - specific handling for Render.com
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. The server may be starting up (Render.com cold start can take 50+ seconds). Please wait and try again.';
    }
    if (error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. The server is taking too long to respond. Please try again.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Connection failed. Please check your internet connection and try again. If the problem persists, the server may be starting up.';
    }
    if (error.type == DioExceptionType.unknown) {
      final errorMsg = error.error?.toString() ?? error.message ?? 'Unknown network error';
      if (errorMsg.contains('Failed host lookup')) {
        return 'Cannot reach server. Please check your internet connection.';
      }
      return 'Network error: $errorMsg. The server may be starting up, please try again.';
    }
    
    return error.message ?? 'Network error';
  }
}

