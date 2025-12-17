import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class ApiClient {
  static const String baseUrl = 'http://91.147.104.165:5555/api/v1';
  static final Dio _dio = Dio()
    ..options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    )
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        developer.log('REQUEST[${options.method}] => PATH: ${options.path}');
        developer.log('Headers: ${options.headers}');
        if (options.data != null) {
          developer.log('Request Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        developer.log('Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        developer.log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        developer.log('Error Message: ${e.message}');
        if (e.response != null) {
          developer.log('Error Response: ${e.response?.data}');
        }
        return handler.next(e);
      },
    ));

  static Future<void> init() async {
    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Add auth token if exists
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            developer.log('Added auth token to request');
          } else {
            developer.log('No auth token found');
          }
        } catch (e) {
          developer.log('Error in request interceptor: $e');
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        developer.log('Error in request: ${error.message}');
        
        // Handle 401 Unauthorized
        if (error.response?.statusCode == 401) {
          developer.log('401 Unauthorized, attempting token refresh...');
          
          // Try to refresh token
          try {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');
            
            if (refreshToken == null) {
              developer.log('No refresh token available, redirecting to login');
              // TODO: Navigate to login screen
              return handler.next(error);
            }
            
            final response = await _dio.post(
              '/auth/refresh',
              data: {'refresh_token': refreshToken},
            );
            
            if (response.statusCode == 200 && response.data['access_token'] != null) {
              final newToken = response.data['access_token'];
              await prefs.setString('access_token', newToken);
              developer.log('Successfully refreshed access token');
              
              // Update the request header
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              
              // Repeat the request
              try {
                final retryResponse = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                developer.log('Retry request successful');
                return handler.resolve(retryResponse);
              } catch (retryError) {
                developer.log('Retry request failed: $retryError');
                return handler.next(error);
              }
            }
          } catch (e) {
            developer.log('Error refreshing token: $e');
            // If refresh fails, clear tokens
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('access_token');
              await prefs.remove('refresh_token');
              // TODO: Navigate to login screen
            } catch (e) {
              developer.log('Error clearing tokens: $e');
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
