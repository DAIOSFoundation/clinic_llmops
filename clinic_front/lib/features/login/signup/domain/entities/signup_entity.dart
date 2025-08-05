import 'package:equatable/equatable.dart';

class SignupEntity extends Equatable {
  final String email;
  final String name;
  final String password;

  const SignupEntity({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}
