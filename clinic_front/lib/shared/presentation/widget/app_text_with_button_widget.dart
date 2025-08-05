import 'package:banya_llmops/shared/presentation/widget/app_default_button.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTextWithButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressedLeft;
  final String buttonLabelLeft;
  final bool isDisabledLeft;
  final VoidCallback? onPressedRight;
  final String buttonLabelRight;
  final bool isDisabledRight;

  const AppTextWithButtonWidget({
    super.key,
    required this.text,
    this.onPressedLeft,
    this.buttonLabelLeft = 'Edit',
    this.isDisabledLeft = false,
    this.onPressedRight,
    this.buttonLabelRight = 'Delete',
    this.isDisabledRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(text, style: AppTextStyles.title(context))),
        AppDefaultButton(
          onPressed: isDisabledLeft ? null : onPressedLeft,
          title: buttonLabelLeft,
          color: AppColors.white,
          fontColor: isDisabledLeft ? AppColors.grey : AppColors.black,
        ),
        const SizedBox(width: 8.0),
        AppDefaultButton(
          onPressed: isDisabledRight ? null : onPressedRight,
          title: buttonLabelRight,
          color: AppColors.white,
          fontColor: isDisabledRight ? AppColors.grey : AppColors.black,
        ),
      ],
    );
  }
}
