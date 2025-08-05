import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_bloc.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_event.dart';
import 'package:banya_llmops/features/login/signup/presentation/blocs/signup_state.dart';
import 'package:banya_llmops/shared/presentation/widget/app_default_button.dart';
import 'package:banya_llmops/shared/presentation/widget/app_dialog.dart';
import 'package:banya_llmops/shared/presentation/widget/app_text_form_field_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'SigupScreen';
  static const routePath = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isCreateButtonEnabled = false;

  late final List<TextEditingController> _controllers;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controllers = [
      _emailController,
      _nameController,
      _passwordController,
      _passwordConfirmController,
    ];

    for (final controller in _controllers) {
      controller.addListener(_updateButtonState);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.removeListener(_updateButtonState);
      controller.dispose();
    }
    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFormValid =
        _emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty &&
        _passwordController.text == _passwordConfirmController.text;

    if (_isCreateButtonEnabled != isFormValid) {
      setState(() {
        _isCreateButtonEnabled = isFormValid;
      });
    }
  }

  void _handleSignupOnPress() {
    if (!_isCreateButtonEnabled) return;

    context.read<SignupBloc>().add(
      SignupSubmitted(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            context.go('/login');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('회원가입 되었습니다.')));
          } else if (state is SignupError) {
            AppDialog.show(
              context: context,
              title: '오류',
              content: state.message,
            );
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '회원가입',
                              style: AppTextStyles.titleLg(
                                context,
                              ).copyWith(fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSizes.appPadding),
                            AppTextformfieldWidget(
                              controller: _emailController,
                              hintText: "이메일",
                              icon: Icons.email,
                              onChanged: (value) {},
                              onFieldSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_nameFocusNode);
                              },
                            ),
                            const SizedBox(height: AppSizes.appPadding / 2),
                            AppTextformfieldWidget(
                              controller: _nameController,
                              hintText: "닉네임",
                              icon: Icons.person,
                              onChanged: (value) {},
                              onFieldSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_passwordFocusNode);
                              },
                            ),
                            const SizedBox(height: AppSizes.appPadding / 2),
                            AppTextformfieldWidget(
                              controller: _passwordController,
                              hintText: "패스워드",
                              icon: Icons.password,
                              isPassword: true,
                              focusNode: _passwordFocusNode,
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: AppSizes.appPadding / 2),
                            AppTextformfieldWidget(
                              controller: _passwordConfirmController,
                              hintText: "패스워드 확인",
                              icon: Icons.password,
                              isPassword: true,
                              focusNode: _passwordConfirmFocusNode,
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: AppSizes.appPadding),
                            AppDefaultButton(
                              title: "회원가입",
                              height: 55.0,
                              width: double.infinity,
                              onPressed: _handleSignupOnPress,
                              isDisable: !_isCreateButtonEnabled,
                              child:
                                  state is SignupLoading
                                      ? const CircularProgressIndicator(
                                        color: AppColors.white,
                                      )
                                      : Text(
                                        "회원가입",
                                        style: AppTextStyles.labelLg(
                                          context,
                                        ).copyWith(color: AppColors.white),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
