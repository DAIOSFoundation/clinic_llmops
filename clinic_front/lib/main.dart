import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/injection.dart';
import 'package:banya_llmops/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'app/app.dart';

void
main() async {
  AppEnv.init(
    AppEnvironment.PROD,
  );

  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;

  initDependencies();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setUrlStrategy(
    PathUrlStrategy(),
  );

  // 앱 시작 시 인증 상태 확인
  final authService =
      getIt<
        AuthService
      >();
  final isAuthenticated =
      await authService.isAuthenticated();

  runApp(
    App(
      initialAuthState:
          isAuthenticated,
    ),
  );
}
