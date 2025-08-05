import 'package:banya_llmops/core/blocs/auth/auth_bloc.dart';
import 'package:banya_llmops/features/login/domain/usecases/login_usecase.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_bloc.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_event.dart';
import 'package:banya_llmops/features/login/presentation/widgets/intro_widget.dart';
import 'package:banya_llmops/features/login/presentation/widgets/login_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatelessWidget {
  static const routePath = '/login';
  static const routeName = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!AppResponsiveWidget.isTablet(context))
            const Expanded(flex: 1, child: IntroWidget()),
          Expanded(
            flex: 1,
            child: BlocProvider(
              create:
                  (context) => LoginBloc(
                    loginUsecase: GetIt.instance<LoginUsecase>(),
                    authBloc: GetIt.instance<AuthBloc>(),
                  ),
              child: const LoginWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
