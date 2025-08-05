import 'dart:io';

import 'package:banya_llmops/shared/exceptions/base_exception.dart';

class ApiException extends BaseException {
  ApiException({required super.message, super.statusCode});

  factory ApiException.fromStatusCode(int statusCode, {String? message}) {
    message ??= switch (statusCode) {
      HttpStatus.serviceUnavailable => 'Service Unavailable',
      HttpStatus.requestTimeout => 'Request Timeout',
      HttpStatus.unauthorized => 'Unauthorized',
      _ => 'Unknown Error',
    };
    return ApiException(message: message, statusCode: statusCode);
  }
}
