import 'package:banya_llmops/core/blocs/auth/auth_bloc.dart';
import 'package:banya_llmops/core/blocs/auth/auth_event.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';
import 'package:banya_llmops/features/login/domain/usecases/login_usecase.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_event.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  final AuthBloc authBloc;

  LoginBloc({required this.loginUsecase, required this.authBloc})
    : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final loginEntity = LoginEntity(
        email: event.email,
        password: event.password,
      );

      final result = await loginUsecase(loginEntity);

      authBloc.add(LoggedIn(user: result));

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
