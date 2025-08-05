import 'package:banya_llmops/core/blocs/auth/auth_bloc.dart';
import 'package:banya_llmops/core/blocs/auth/auth_event.dart';
import 'package:banya_llmops/features/login/domain/entities/login_entity.dart';
import 'package:banya_llmops/features/login/domain/usecases/login_usecase.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_event.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_state.dart';
import 'package:banya_llmops/shared/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  final AuthBloc authBloc;
  final AuthService authService;

  LoginBloc({required this.loginUsecase, required this.authBloc})
    : authService = GetIt.instance<AuthService>(),
      super(LoginInitial()) {
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

      // AuthService 업데이트
      await authService.onLoginSuccess(
        result.accessToken,
        result.refreshToken,
      );

      authBloc.add(LoggedIn(user: result.user.toEntity()));

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
