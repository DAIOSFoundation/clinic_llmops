import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup_model.g.dart';

@JsonSerializable()
class SignupModel extends Equatable {
  final String email;
  final String name;
  final String password;

  const SignupModel({
    required this.email,
    required this.name,
    required this.password,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignupModelToJson(this);

  @override
  List<Object?> get props => [email, name, password];
}
