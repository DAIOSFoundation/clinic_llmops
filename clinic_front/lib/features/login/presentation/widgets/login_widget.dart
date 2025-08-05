import 'package:banya_llmops/features/login/presentation/blocs/login_bloc.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_event.dart';
import 'package:banya_llmops/features/login/presentation/blocs/login_state.dart';
import 'package:banya_llmops/features/login/signup/presentation/screens/signup_screen.dart';
import 'package:banya_llmops/shared/presentation/widget/app_default_button.dart';
import 'package:banya_llmops/shared/presentation/widget/app_dialog.dart';
import 'package:banya_llmops/shared/presentation/widget/app_text_form_field_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginWidget
    extends
        StatefulWidget {
  const LoginWidget({
    super.key,
  });

  @override
  State<
    LoginWidget
  >
  createState() =>
      _LoginWidgetState();
}

class _LoginWidgetState
    extends
        State<
          LoginWidget
        > {
  bool _isLoginButtonEnabled =
      false;

  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final FocusNode _passwordFocusNode =
      FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(
      _updateButtonState,
    );
    _passwordController.addListener(
      _updateButtonState,
    );
    _emailController.text = 'test@example.com';
    _passwordController.text = 'test1234';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFormValid =
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    if (_isLoginButtonEnabled !=
        isFormValid) {
      setState(
        () {
          _isLoginButtonEnabled =
              isFormValid;
        },
      );
    }
  }

  void _handleLoginOnPress() {
    if (!_isLoginButtonEnabled) return;

    context
        .read<
          LoginBloc
        >()
        .add(
          LoginSubmitted(
            email:
                _emailController.text,
            password:
                _passwordController.text,
          ),
        );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.white,
      body: BlocListener<
        LoginBloc,
        LoginState
      >(
        listener: (
          context,
          state,
        ) {
          if (state
              is LoginSuccess) {
            context.go(
              '/',
            );
          } else if (state
              is LoginError) {
            AppDialog.show(
              context:
                  context,
              title:
                  '오류',
              content:
                  state.message,
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                    400,
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(
                    24,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.white,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(
                          alpha:
                              0.3,
                        ),
                        blurRadius:
                            10,
                        offset: const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '로그인',
                        style: AppTextStyles.titleLg(
                          context,
                        ).copyWith(
                          fontSize:
                              28,
                        ),
                        textAlign:
                            TextAlign.center,
                      ),
                      const SizedBox(
                        height:
                            AppSizes.appPadding,
                      ),
                      AppTextformfieldWidget(
                        controller:
                            _emailController,
                        hintText:
                            "이메일",
                        icon:
                            Icons.email,
                        onFieldSubmitted: (
                          _,
                        ) {
                          FocusScope.of(
                            context,
                          ).requestFocus(
                            _passwordFocusNode,
                          );
                        },
                      ),
                      const SizedBox(
                        height:
                            AppSizes.appPadding /
                            2,
                      ),
                      AppTextformfieldWidget(
                        controller:
                            _passwordController,
                        hintText:
                            "패스워드",
                        icon:
                            Icons.password,
                        isPassword:
                            true,
                        focusNode:
                            _passwordFocusNode,
                      ),
                      const SizedBox(
                        height:
                            AppSizes.appPadding,
                      ),
                      BlocBuilder<
                        LoginBloc,
                        LoginState
                      >(
                        builder: (
                          context,
                          state,
                        ) {
                          return AppDefaultButton(
                            title:
                                "로그인",
                            height:
                                55.0,
                            width:
                                double.infinity,
                            onPressed:
                                _handleLoginOnPress,
                            isDisable:
                                !_isLoginButtonEnabled,
                            child:
                                state
                                        is LoginLoading
                                    ? const CircularProgressIndicator(
                                      color:
                                          AppColors.white,
                                    )
                                    : Text(
                                      "로그인",
                                      style: AppTextStyles.labelLg(
                                        context,
                                      ).copyWith(
                                        color:
                                            AppColors.white,
                                      ),
                                    ),
                          );
                        },
                      ),
                      const SizedBox(
                        height:
                            10,
                      ),
                      TextButton(
                        onPressed:
                            () => context.pushNamed(
                              SignupScreen.routeName,
                            ),
                        child: Text(
                          "회원가입",
                          style: AppTextStyles.labelLg(
                            context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
