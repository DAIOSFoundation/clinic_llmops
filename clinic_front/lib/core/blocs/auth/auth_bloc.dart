import 'package:banya_llmops/core/blocs/auth/auth_event.dart';
import 'package:banya_llmops/core/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoggedIn>(_onLoggedIn);
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(user: event.user));
  }
}
