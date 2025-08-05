import 'package:banya_llmops/features/login/signup/data/models/signup_model.dart';

abstract class SignupDataSource {
  Future<void> signup(SignupModel signupModel);
}
