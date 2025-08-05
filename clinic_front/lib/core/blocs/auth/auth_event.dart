import 'package:banya_llmops/core/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoggedIn extends AuthEvent {
  final UserEntity user;

  const LoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}
