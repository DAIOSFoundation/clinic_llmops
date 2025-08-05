import 'package:banya_llmops/features/login/signup/domain/entities/signup_entity.dart';

abstract class SignupRepository {
  Future<void> signup(SignupEntity signupEntity);
}
