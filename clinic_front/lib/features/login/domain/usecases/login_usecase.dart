import 'package:banya_llmops/data/models/login_response_model.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';
import 'package:banya_llmops/features/login/domain/repositories/login_repository.dart';

class LoginUsecase {
  final LoginRepository repository;
  LoginUsecase(this.repository);

  Future<LoginResponseModel> call(LoginEntity loginEntity) async {
    return await repository.login(loginEntity);
  }
}
