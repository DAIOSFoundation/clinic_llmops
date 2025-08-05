import 'package:banya_llmops/data/models/login_response_model.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(LoginEntity loginEntity);
}
