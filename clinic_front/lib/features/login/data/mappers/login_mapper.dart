import 'package:banya_llmops/features/login/data/models/login_model.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';

extension LoginModelToEntityMapper on LoginModel {
  LoginEntity toEntity() {
    return LoginEntity(email: email, password: password);
  }
}

extension LoginEntityToModelMapper on LoginEntity {
  LoginModel toModel() {
    return LoginModel(email: email, password: password);
  }
}
