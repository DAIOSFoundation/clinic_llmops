import 'dart:io';

import 'package:dio/dio.dart';
import 'api_exception.dart';

class ExceptionHandler {
  static ApiException handleException(dynamic e, {String endpoint = ''}) {
    int statusCode = HttpStatus.internalServerError;
    String message = '알 수 없는 오류가 발생했습니다.';

    if (e is SocketException) {
      message = '서버에 연결할 수 없습니다.';
      statusCode = HttpStatus.serviceUnavailable;
    } else if (e is DioException) {
      statusCode = e.response?.statusCode ?? HttpStatus.internalServerError;
      final errorData = e.response?.data;
      final errorMessage = _extractDioErrorMessage(errorData) ?? e.message;
      return ApiException.fromStatusCode(statusCode, message: errorMessage);
    }

    return ApiException(message: message, statusCode: statusCode);
  }

  static String? _extractDioErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }
}
