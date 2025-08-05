import 'package:banya_llmops/data/models/user_model.dart';
import 'package:banya_llmops/data/models/login_response_model.dart';
import 'package:banya_llmops/data/network/network_service.dart';
import 'package:banya_llmops/features/login/data/datasources/login_datasource.dart';
import 'package:banya_llmops/features/login/data/models/login_model.dart';
import 'package:banya_llmops/shared/exceptions/api_exception.dart';
import 'package:banya_llmops/shared/exceptions/exception_handler.dart';
import 'package:banya_llmops/shared/services/token_service.dart';
import 'package:banya_llmops/shared/utils/base64_encoder.dart';

class LoginRemoteDataSource implements LoginDataSource {
  final NetworkService networkService;

  LoginRemoteDataSource(this.networkService);

  @override
  Future<UserModel> login(LoginModel loginModel) async {
    const String endpoint = '/api/v1/users/login';
    try {
      final encodedHeader = Base64Encoder.encodeCredentials(
        loginModel.email,
        loginModel.password,
      );

      final resp = await networkService.post(
        endpoint,
        headers: {'Authorization': 'Basic $encodedHeader'},
      );

      if (resp.statusCode != 200) {
        throw ApiException(
          message: 'Error fetching login data: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      if (resp.data == null || resp.data is! Map<String, dynamic>) {
        throw ApiException(
          message: 'login data is null',
          statusCode: resp.statusCode,
        );
      }

      final Map<String, dynamic> rawResp = resp.data as Map<String, dynamic>;
      final Map<String, dynamic>? data = rawResp['data'];

      if (data == null) {
        throw ApiException(
          message: 'login data data is null',
          statusCode: resp.statusCode,
        );
      }

      // JWT 토큰 응답 처리
      final loginResponse = LoginResponseModel.fromJson(data);

      // 토큰 저장
      await TokenService.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      return loginResponse.user;
    } on ApiException {
      rethrow;
    } catch (e) {
      print(e);
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }
}
