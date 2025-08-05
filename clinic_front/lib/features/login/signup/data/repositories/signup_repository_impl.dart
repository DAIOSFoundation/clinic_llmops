import 'package:banya_llmops/features/login/signup/data/datasources/signup_datasource.dart';
import 'package:banya_llmops/features/login/signup/data/mappers/signup_model_mapper.dart';
import 'package:banya_llmops/features/login/signup/domain/entities/signup_entity.dart';
import 'package:banya_llmops/features/login/signup/domain/repositories/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final SignupDataSource signupDataSource;
  const SignupRepositoryImpl({required this.signupDataSource});

  @override
  Future<void> signup(SignupEntity signupEntity) async {
    try {
      final signupModel = signupEntity.toModel();
      await signupDataSource.signup(signupModel);
    } catch (e) {
      rethrow;
    }
  }
}
