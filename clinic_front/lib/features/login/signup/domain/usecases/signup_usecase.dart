import 'package:banya_llmops/features/login/signup/domain/entities/signup_entity.dart';
import 'package:banya_llmops/features/login/signup/domain/repositories/signup_repository.dart';

class SignupUsecase {
  final SignupRepository repository;

  const SignupUsecase(this.repository);

  Future<void> call(SignupEntity signupEntity) async {
    return await repository.signup(signupEntity);
  }
}
