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
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
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
  }) async {
    try {
      print('[API] GET $path');
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      print('[API Success] GET $path - Status: ${response.statusCode}');
      return fromJson(response.data);
    } on DioException catch (e) {
      final error = _handleError(e);
      print('[API Failed] GET $path: $error');
      throw error;
    }
  }

  Future<T> patch<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      print('[API] PATCH $path');
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
      );
      print('[API Success] PATCH $path - Status: ${response.statusCode}');
      return fromJson(response.data);
    } on DioException catch (e) {
      final error = _handleError(e);
      print('[API Failed] PATCH $path: $error');
      throw error;
    }
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
    
    // Connection errors
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout - is the API server running?';
    }
    if (error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout - API server is slow or not responding';
    }
    if (error.type == DioExceptionType.unknown) {
      return 'Network error - ${error.message}. Make sure the API server is running.';
    }
    
    return error.message ?? 'Network error';
  }
}

