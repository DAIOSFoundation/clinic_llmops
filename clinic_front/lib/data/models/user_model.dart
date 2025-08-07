import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:banya_llmops/core/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      imageUrl: imageUrl,
    );
  }
  
  @override
  List<Object?> get props => [id, name, email, imageUrl];
}
