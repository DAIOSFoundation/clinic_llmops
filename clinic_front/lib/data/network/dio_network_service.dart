import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/data/network/network_service.dart';
import 'package:banya_llmops/shared/exceptions/exception_handler.dart';
import 'package:banya_llmops/shared/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioNetworkService extends NetworkService {
  final Dio dio;
  final AuthService? authService;

  DioNetworkService(this.dio, {this.authService}) {
    dio.options = _dioBaseOptions;
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    if (authService != null) {
      dio.interceptors.add(_AuthInterceptor(authService!));
    }
  }

  BaseOptions get _dioBaseOptions => BaseOptions(
    baseUrl: AppEnv.baseURL,
    headers: headers,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(hours: 1), // 1시간으로 변경
  );

  @override
  String get baseUrl => AppEnv.baseURL;

  @override
  Map<String, Object> get headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  @override
  Map<String, dynamic> updateHeader(Map<String, dynamic> data) {
    final merged = {...headers, ...data};
    dio.options.headers = merged;
    return merged;
  }

  @override
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    void Function(int count, int total)? onSendProgress,
    String? contentType,
  }) async {
    try {
      final Options requestOptions = Options(
        headers: headers,
        contentType: contentType ?? 'application/json',
      );

      return await dio.post(
        endpoint,
        data: data,
        options: requestOptions,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    void Function(int count, int total)? onSendProgress,
    String? contentType,
  }) async {
    try {
      final Options requestOptions = Options(
        headers: headers,
        contentType: contentType ?? 'application/json',
      );

      return await dio.patch(
        endpoint,
        data: data,
        options: requestOptions,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    String? contentType,
  }) async {
    try {
      final Options requestOptions = Options(
        headers: headers,
        contentType: contentType ?? 'application/json',
      );

      return await dio.delete(endpoint, data: data, options: requestOptions);
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }
}

// JWT 토큰 자동 처리 인터셉터
class _AuthInterceptor extends Interceptor {
  final AuthService authService;

  _AuthInterceptor(this.authService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 로그인 엔드포인트는 토큰을 추가하지 않음
    if (options.path.contains('/users/login') ||
        options.path.contains('/users/register')) {
      handler.next(options);
      return;
    }

    // Authorization 헤더가 없으면 토큰 추가
    if (!options.headers.containsKey('Authorization')) {
      final authHeader = await authService.getAuthorizationHeader();
      if (authHeader != null) {
        options.headers['Authorization'] = authHeader;
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 시 토큰 갱신 시도
    if (err.response?.statusCode == 401) {
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        // 토큰 갱신 성공 시 원래 요청 재시도
        final authHeader = await authService.getAuthorizationHeader();
        if (authHeader != null) {
          err.requestOptions.headers['Authorization'] = authHeader;

          try {
            final response = await Dio().fetch(err.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            // 재시도 실패 시 로그아웃
            await authService.logout();
          }
        }
      } else {
        // 토큰 갱신 실패 시 로그아웃
        await authService.logout();
      }
    }

    handler.next(err);
  }
}
