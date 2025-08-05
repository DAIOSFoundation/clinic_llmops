// ignore: constant_identifier_names
enum AppEnvironment {
  DEV,
  PROD,
}

abstract class AppEnv {
  static AppEnvironment _environment =
      AppEnvironment.DEV;

  static void init(
    AppEnvironment environment,
  ) {
    AppEnv._environment = environment;
  }

  static String get appName =>
      _environment._appName;
  static String get baseURL =>
      _environment._baseURL;
  static AppEnvironment get environment =>
      _environment;
}

extension _EnvProperties
    on
        AppEnvironment {
  static const _appNames = {
    AppEnvironment.DEV: 'NXDF LLMOps',
    AppEnvironment.PROD: 'NXDF LLMOps',
  };

  static const _baseURLs = {
    AppEnvironment.DEV: 'http://localhost:8000',
    AppEnvironment.PROD: 'http://localhost:8000',
    // AppEnvironment.DEV: 'https://api-llmops.banya.ai',
    // AppEnvironment.PROD: 'https://api-llmops.banya.ai',
  };

  String get _appName =>
      _appNames[this]!;
  String get _baseURL =>
      _baseURLs[this]!;
}
