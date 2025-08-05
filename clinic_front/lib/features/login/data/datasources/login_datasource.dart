import 'package:banya_llmops/data/models/login_response_model.dart';
import 'package:banya_llmops/features/login/data/models/login_model.dart';

abstract class LoginDataSource {
  Future<LoginResponseModel> login(LoginModel loginModel);
}
