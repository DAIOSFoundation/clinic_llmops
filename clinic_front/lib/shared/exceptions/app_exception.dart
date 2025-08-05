import 'package:banya_llmops/shared/exceptions/base_exception.dart';

class AppException extends BaseException {
  AppException({required super.message, super.statusCode});
}
