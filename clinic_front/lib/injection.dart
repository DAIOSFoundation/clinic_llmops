import 'package:banya_llmops/core/blocs/auth/auth_bloc.dart';
import 'package:banya_llmops/data/network/dio_network_service.dart';
import 'package:banya_llmops/data/network/network_service.dart';
import 'package:banya_llmops/features/home/rag/data/datasources/rag_datasource.dart';
import 'package:banya_llmops/features/home/rag/data/datasources/rag_remote_datasource.dart';
import 'package:banya_llmops/features/home/rag/data/repositories/rag_repository_impl.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/create_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/delete_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/edit_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rag_detail_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rags_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/upload_rag_file_usecase.dart';
import 'package:banya_llmops/features/login/data/datasources/login_datasource.dart';
import 'package:banya_llmops/features/login/data/datasources/login_remote_datasource.dart';
import 'package:banya_llmops/features/login/data/repositories/login_repository_impl.dart';
import 'package:banya_llmops/features/login/domain/repositories/login_repository.dart';
import 'package:banya_llmops/features/login/domain/usecases/login_usecase.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_bloc.dart';
import 'package:banya_llmops/features/login/signup/data/datasources/signup_datasource.dart';
import 'package:banya_llmops/features/login/signup/data/datasources/signup_remote_datasource.dart';
import 'package:banya_llmops/features/login/signup/data/repositories/signup_repository_impl.dart';
import 'package:banya_llmops/features/login/signup/domain/repositories/signup_repository.dart';
import 'package:banya_llmops/features/login/signup/domain/usecases/signup_usecase.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_bloc.dart';
import 'package:banya_llmops/shared/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // 1. 일반 API 통신용 Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));

  getIt.registerLazySingleton<NetworkService>(
    () => DioNetworkService(getIt<Dio>(), authService: getIt<AuthService>()),
  );

  //Login
  getIt.registerFactory<LoginUsecase>(
    () => LoginUsecase(getIt<LoginRepository>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      loginUsecase: getIt<LoginUsecase>(),
      authBloc: getIt<AuthBloc>(),
    ),
  );
  getIt.registerFactory<LoginDataSource>(
    () => LoginRemoteDataSource(getIt<NetworkService>()),
  );
  getIt.registerFactory<LoginRepository>(
    () => LoginRepositoryImpl(loginDataSource: getIt<LoginDataSource>()),
  );

  //Signup
  getIt.registerFactory<SignupUsecase>(
    () => SignupUsecase(getIt<SignupRepository>()),
  );
  getIt.registerFactory<SignupBloc>(
    () => SignupBloc(signupUsecase: getIt<SignupUsecase>()),
  );
  getIt.registerFactory<SignupDataSource>(
    () => SignupRemoteDataSource(getIt<NetworkService>()),
  );
  getIt.registerFactory<SignupRepository>(
    () => SignupRepositoryImpl(signupDataSource: getIt<SignupDataSource>()),
  );

  //AUTH
  getIt.registerSingleton<AuthBloc>(AuthBloc());

  //RAG
  getIt.registerLazySingleton<RagDataSource>(
    () => RagRemoteDataSource(networkService: getIt<NetworkService>()),
  );
  getIt.registerLazySingleton<RagRepository>(
    () => RagRepositoryImpl(ragDataSource: getIt<RagDataSource>()),
  );
  getIt.registerLazySingleton(() => FetchRagsUsecase(getIt<RagRepository>()));
  getIt.registerLazySingleton(
    () => FetchRagDetailUsecase(getIt<RagRepository>()),
  );
  getIt.registerLazySingleton(() => CreateRagUsecase(getIt<RagRepository>()));
  getIt.registerLazySingleton(() => EditRagUsecase(getIt<RagRepository>()));
  getIt.registerLazySingleton(() => DeleteRagUsecase(getIt<RagRepository>()));
  getIt.registerLazySingleton(
    () => UploadRagFileUsecase(getIt<RagRepository>()),
  );
}
