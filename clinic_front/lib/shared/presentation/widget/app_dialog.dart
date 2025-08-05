import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(title, style: AppTextStyles.label(context)),
          content: Text(content, style: AppTextStyles.labelSm(context)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '닫기',
                style: AppTextStyles.labelSm(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
