import 'package:banya_llmops/data/network/network_service.dart';
import 'package:banya_llmops/features/login/signup/data/datasources/signup_datasource.dart';
import 'package:banya_llmops/features/login/signup/data/models/signup_model.dart';
import 'package:banya_llmops/shared/exceptions/api_exception.dart';
import 'package:banya_llmops/shared/exceptions/exception_handler.dart';

class SignupRemoteDataSource implements SignupDataSource {
  final NetworkService networkService;

  SignupRemoteDataSource(this.networkService);

  @override
  Future<void> signup(SignupModel signupModel) async {
    const String endpoint = '/api/v1/users/register';
    try {
      final resp = await networkService.post(
        endpoint,
        data: signupModel.toJson(),
      );

      if (resp.statusCode != 201) {
        throw ApiException(
          message: 'Error fetching signup data: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }
}
