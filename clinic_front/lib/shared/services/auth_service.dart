import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/shared/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// 1. ChangeNotifier를 상속받습니다.
class AuthService extends ChangeNotifier {
  final Dio dio;

  bool _isLoggedIn = false;
  bool _isInitialized = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  AuthService(this.dio) {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoggedIn = await TokenService.hasTokens();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> onLoginSuccess(String accessToken, String refreshToken) async {
    await TokenService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await TokenService.clearTokens();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    return await TokenService.hasTokens();
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null) {
        if (_isLoggedIn) {
          _isLoggedIn = false;
          notifyListeners();
        }
        return false;
      }

      final resp = await dio.post(
        '${AppEnv.baseURL}/api/v1/users/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final Map<String, dynamic> data = resp.data as Map<String, dynamic>;
        final String newAccessToken = data['access_token'];

        await TokenService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        );

        if (!_isLoggedIn) {
          _isLoggedIn = true;
          notifyListeners();
        }
        return true;
      }

      await logout();
      return false;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<String?> getAuthorizationHeader() async {
    return await TokenService.getAuthorizationHeader();
  }
}
