abstract class BaseException implements Exception {
  final String message;
  final int? statusCode;

  BaseException({required this.message, this.statusCode});

  @override
  String toString() => 'Exception: $message (statusCode: $statusCode)';
}
