import 'package:equatable/equatable.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String name;
  final String password;

  const SignupSubmitted({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}
