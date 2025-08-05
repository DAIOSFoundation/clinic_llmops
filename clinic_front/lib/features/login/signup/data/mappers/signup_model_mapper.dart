import 'package:banya_llmops/features/login/signup/data/models/signup_model.dart';
import 'package:banya_llmops/features/login/signup/domain/entities/signup_entity.dart';

extension SignupModelToEntityMapper on SignupModel {
  SignupEntity toEntity() =>
      SignupEntity(email: email, name: name, password: password);
}

extension SignupEntityToModelMapper on SignupEntity {
  SignupModel toModel() =>
      SignupModel(email: email, name: name, password: password);
}
