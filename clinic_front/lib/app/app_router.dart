import 'package:banya_llmops/features/home/presentation/screens/sidebar_layout.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/create_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/delete_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/edit_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rag_detail_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rags_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/upload_rag_file_usecase.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_bloc.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_create_screen.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_detail_screen.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_edit_screen.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_screen.dart';
import 'package:banya_llmops/features/login/presentation/screens/login_screen.dart';
import 'package:banya_llmops/features/login/signup/domain/usecases/signup_usecase.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_bloc.dart';
import 'package:banya_llmops/features/login/signup/presentation/screens/signup_screen.dart';
import 'package:banya_llmops/shared/presentation/screens/shared_error_screen.dart';
import 'package:banya_llmops/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final AuthService authService = GetIt.instance<AuthService>();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final router = GoRouter(
  refreshListenable: authService,
  initialLocation: LoginScreen.routePath,

  redirect: (context, state) {
    if (!authService.isInitialized) {
      return null;
    }

    final isLoggedIn = authService.isLoggedIn;
    final location = state.fullPath ?? '';

    final isAuthenticating =
        location == LoginScreen.routePath || location == SignupScreen.routePath;

    if (!isLoggedIn && !isAuthenticating) {
      return LoginScreen.routePath;
    }

    if (isLoggedIn && isAuthenticating) {
      return RagScreen.routePath;
    }

    return null;
  },

  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return SideBarLayout(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: RagScreen.routePath,
          name: RagScreen.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider(
                create:
                    (context) => RagBloc(
                      fetchRagsUsecase: GetIt.instance<FetchRagsUsecase>(),
                      fetchRagDetailUsecase:
                          GetIt.instance<FetchRagDetailUsecase>(),
                      createRagUsecase: GetIt.instance<CreateRagUsecase>(),
                      editRagUsecase: GetIt.instance<EditRagUsecase>(),
                      uploadRagFileUsecase:
                          GetIt.instance<UploadRagFileUsecase>(),
                      deleteRagUsecase: GetIt.instance<DeleteRagUsecase>(),
                    ),
                child: const RagScreen(),
              ),
              transitionDuration: const Duration(milliseconds: 0),
              reverseTransitionDuration: const Duration(milliseconds: 0),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeIn,
                  ),
                  child: child,
                );
              },
            );
          },
          routes: [
            GoRoute(
              path: RagCreateScreen.routePath,
              name: RagCreateScreen.routeName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create:
                        (context) => RagBloc(
                          fetchRagsUsecase: GetIt.instance<FetchRagsUsecase>(),
                          fetchRagDetailUsecase:
                              GetIt.instance<FetchRagDetailUsecase>(),
                          createRagUsecase: GetIt.instance<CreateRagUsecase>(),
                          editRagUsecase: GetIt.instance<EditRagUsecase>(),
                          uploadRagFileUsecase:
                              GetIt.instance<UploadRagFileUsecase>(),
                          deleteRagUsecase: GetIt.instance<DeleteRagUsecase>(),
                        ),
                    child: const RagCreateScreen(),
                  ),
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: RAGDetailScreen.routePath,
              name: RAGDetailScreen.routeName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create:
                        (context) => RagBloc(
                          fetchRagsUsecase: GetIt.instance<FetchRagsUsecase>(),
                          fetchRagDetailUsecase:
                              GetIt.instance<FetchRagDetailUsecase>(),
                          createRagUsecase: GetIt.instance<CreateRagUsecase>(),
                          editRagUsecase: GetIt.instance<EditRagUsecase>(),
                          uploadRagFileUsecase:
                              GetIt.instance<UploadRagFileUsecase>(),
                          deleteRagUsecase: GetIt.instance<DeleteRagUsecase>(),
                        ),
                    child: const RAGDetailScreen(),
                  ),
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: RagEditScreen.routePath,
              name: RagEditScreen.routeName,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create:
                        (context) => RagBloc(
                          fetchRagsUsecase: GetIt.instance<FetchRagsUsecase>(),
                          fetchRagDetailUsecase:
                              GetIt.instance<FetchRagDetailUsecase>(),
                          createRagUsecase: GetIt.instance<CreateRagUsecase>(),
                          editRagUsecase: GetIt.instance<EditRagUsecase>(),
                          uploadRagFileUsecase:
                              GetIt.instance<UploadRagFileUsecase>(),
                          deleteRagUsecase: GetIt.instance<DeleteRagUsecase>(),
                        ),
                    child: const RagEditScreen(),
                  ),
                  transitionDuration: const Duration(milliseconds: 0),
                  reverseTransitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),

        GoRoute(
          path: LoginScreen.routePath,
          name: LoginScreen.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const LoginScreen(),
              transitionDuration: Duration.zero,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            );
          },
        ),
        GoRoute(
          path: SignupScreen.routePath,
          name: SignupScreen.routeName,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: BlocProvider(
                create:
                    (context) => SignupBloc(
                      signupUsecase: GetIt.instance<SignupUsecase>(),
                    ),
                child: const SignupScreen(),
              ),
              transitionDuration: Duration.zero,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            );
          },
        ),
      ],
    ),
  ],
  observers: [routeObserver],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const SharedErrorScreen(),
);
