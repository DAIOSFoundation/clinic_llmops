import 'package:banya_llmops/app/app_env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'app/app.dart';

void main() {
  AppEnv.init(AppEnvironment.DEV);

  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setUrlStrategy(PathUrlStrategy());

  runApp(App());
}
