import 'package:dio/dio.dart';

abstract class NetworkService {
  String get baseUrl;

  Map<String, Object> get headers;

  Map<String, dynamic>? updateHeader(Map<String, dynamic> data);

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    void Function(int count, int total)? onSendProgress,
    String? contentType,
  });

  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    void Function(int count, int total)? onSendProgress,
    String? contentType,
  });

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
    String? contentType,
  });
}
