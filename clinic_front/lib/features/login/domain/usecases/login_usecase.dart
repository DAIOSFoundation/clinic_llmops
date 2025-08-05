import 'package:banya_llmops/core/entities/user_entity.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';
import 'package:banya_llmops/features/login/domain/repositories/login_repository.dart';

class LoginUsecase {
  final LoginRepository repository;
  LoginUsecase(this.repository);

  Future<UserEntity> call(LoginEntity loginEntity) async {
    return await repository.login(loginEntity);
  }
}
