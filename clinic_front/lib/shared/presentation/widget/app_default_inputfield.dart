import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class AppDefaultInputField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final Widget? child;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool isPadding;

  const AppDefaultInputField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.child,
    this.obscureText = false,
    this.isPadding = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboardType =
        keyboardType ??
        (maxLines == 1 ? TextInputType.text : TextInputType.multiline);

    final effectiveMinLines = maxLines == null ? (minLines ?? 1) : null;
    final effectiveMaxLines = maxLines;

    return Padding(
      padding: EdgeInsets.only(bottom: isPadding ? AppSizes.appPadding : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [
          if (labelText != null)
            Column(
              children: [
                Row(
                  children: [
                    Text(labelText!, style: AppTextStyles.title(context)),
                    if (child != null) child!,
                  ],
                ),
                SizedBox(height: 8.0),
              ],
            ),

          Container(
            decoration: AppUIStyles.shadowBoxDecoration,
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(minHeight: 44),

            height:
                maxLines == 1
                    ? AppSizes.textFieldHeight
                    : AppSizes.textFieldHeight * 2,

            child: TextField(
              controller: controller,
              maxLines: effectiveMaxLines,
              minLines: effectiveMinLines,
              obscureText: obscureText,
              keyboardType: effectiveKeyboardType,
              style: AppTextStyles.label(context),
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.label(
                  context,
                ).copyWith(color: Colors.grey),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: maxLines == 1 ? true : false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
