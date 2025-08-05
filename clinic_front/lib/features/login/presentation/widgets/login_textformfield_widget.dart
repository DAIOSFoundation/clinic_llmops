import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginTextformfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const LoginTextformfieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppColors.black),
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
        ),
        obscureText: isPassword,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
