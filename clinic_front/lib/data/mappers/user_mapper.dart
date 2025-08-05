import 'package:banya_llmops/core/entities/user_entity.dart';
import 'package:banya_llmops/data/models/user_model.dart';

extension LoginModelToEntityMapper on UserModel {
  UserEntity toEntity() =>
      UserEntity(id: id, name: name, email: email, imageUrl: imageUrl);
}

extension LoginEntityToModelMapper on UserEntity {
  UserModel toModel() =>
      UserModel(id: id, name: name, email: email, imageUrl: imageUrl);
}
