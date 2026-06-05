import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/values/app_env.dart';
import '../../core/values/constants.dart';
import '../local/token_manager.dart';
import 'network_exception.dart';

class ApiClient {
  late Dio _dio;
  final TokenManager _tokenManager = TokenManager();
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.instance.baseUrl,
      connectTimeout: const Duration(milliseconds: Constants.CONNECT_TIMEOUT),
      receiveTimeout: const Duration(milliseconds: Constants.RECEIVE_TIMEOUT),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _tokenManager.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        if (options.data != null) {
          _logger.d('REQUEST BODY: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        _logger.d('DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        
        if (e.response?.statusCode == 401) {
          // Centralized Refresh Token Logic
          final success = await _refreshToken();
          if (success) {
            // Retry the original request
            final options = e.requestOptions;
            final token = _tokenManager.getToken();
            options.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        }
        
        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _tokenManager.getRefreshToken();
      if (refreshToken == null) return false;
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _tokenManager.saveToken(data['access_token'] as String);
        if (data['refresh_token'] != null) {
          await _tokenManager.saveRefreshToken(data['refresh_token'] as String);
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // Add other methods like put, delete, etc.
}
