import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTextformfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const AppTextformfieldWidget({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hintText, style: AppTextStyles.label(context)),
          SizedBox(height: 4.0),
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon),
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              border: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.black),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.blue),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            obscureText: isPassword,
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ],
      ),
    );
  }
}
