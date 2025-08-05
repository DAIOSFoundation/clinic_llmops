import 'package:banya_llmops/data/models/user_model.dart';
import 'package:banya_llmops/features/login/data/models/login_model.dart';

abstract class LoginDataSource {
  Future<UserModel> login(LoginModel loginModel);
}
