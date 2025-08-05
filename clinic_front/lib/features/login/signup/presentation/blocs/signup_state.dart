import 'package:equatable/equatable.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final String message;

  const SignupError(this.message);

  @override
  List<Object?> get props => [message];
}
