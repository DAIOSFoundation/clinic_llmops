import 'package:banya_llmops/core/entities/user_entity.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<UserEntity> login(LoginEntity loginEntity);
}
