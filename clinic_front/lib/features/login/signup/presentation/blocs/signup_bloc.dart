import 'package:banya_llmops/features/login/signup/domain/entities/signup_entity.dart';
import 'package:banya_llmops/features/login/signup/domain/usecases/signup_usecase.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_event.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase signupUsecase;
  SignupBloc({required this.signupUsecase}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    try {
      final signupEntity = SignupEntity(
        email: event.email,
        name: event.name,
        password: event.password,
      );
      await signupUsecase(signupEntity);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
