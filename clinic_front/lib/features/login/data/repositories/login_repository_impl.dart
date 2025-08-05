import 'package:banya_llmops/core/entities/user_entity.dart';
import 'package:banya_llmops/data/mappers/user_mapper.dart';
import 'package:banya_llmops/features/login/data/datasources/login_datasource.dart';
import 'package:banya_llmops/features/login/data/mappers/login_mapper.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';
import 'package:banya_llmops/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginDataSource loginDataSource;
  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<UserEntity> login(LoginEntity loginEntity) async {
    try {
      final user = await loginDataSource.login(loginEntity.toModel());

      return user.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
