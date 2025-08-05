import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/app/app_router.dart';
import 'package:banya_llmops/core/blocs/auth/auth_bloc.dart';
import 'package:banya_llmops/core/blocs/auth/auth_state.dart';
import 'package:banya_llmops/injection.dart';
import 'package:banya_llmops/shared/presentation/widget/app_scroll_behavior.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App
    extends
        StatelessWidget {
  final bool? initialAuthState;

  App({
    super.key,
    this.initialAuthState,
  });

  final ThemeData theme = ThemeData(
    useMaterial3:
        true,
    splashColor:
        Colors.transparent,
    highlightColor:
        Colors.transparent,
    splashFactory:
        NoSplash.splashFactory,
    scaffoldBackgroundColor:
        AppColors.black,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor:
          AppColors.lightBlue,
    ),

    fontFamily:
        'Inter',
    textTheme:
        const TextTheme(),
    fontFamilyFallback: [
      'Inter',
      'Apple Color Emoji',
      'Noto Color Emoji',
      'sans-serif',
    ],
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<
          AuthBloc
        >.value(
          value:
              getIt<
                AuthBloc
              >(),
        ),
      ],
      child: BlocListener<
        AuthBloc,
        AuthState
      >(
        listenWhen:
            (
              previous,
              current,
            ) =>
                previous
                    is! AuthAuthenticated &&
                current
                    is AuthAuthenticated,
        listener:
            (
              context,
              state,
            ) {},
        child: MaterialApp.router(
          title:
              AppEnv.appName,
          scrollBehavior:
              AppScrollBehavior(),
          theme:
              theme,
          routeInformationParser:
              router.routeInformationParser,
          routerDelegate:
              router.routerDelegate,
          routeInformationProvider:
              router.routeInformationProvider,
          debugShowCheckedModeBanner:
              false,
          builder: (
            context,
            child,
          ) {
            final mediaQuery = MediaQuery.of(
              context,
            );
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                  (1.0 >
                          mediaQuery.textScaler.scale(
                            1.0,
                          ))
                      ? 1.0
                      : mediaQuery.textScaler.scale(
                        1.0,
                      ),
                ),
              ),
              child:
                  child!,
            );
          },
        ),
      ),
    );
  }
}
