import 'dart:convert';

class Base64Encoder {
  static String encodeCredentials(String email, String password) {
    final credentials = '$email:$password';
    final bytes = utf8.encode(credentials);
    return base64Encode(bytes);
  }
}
