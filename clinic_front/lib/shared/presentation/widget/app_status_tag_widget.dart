import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppStatusTagWidget extends StatelessWidget {
  final String status;

  const AppStatusTagWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = AppUIStyles.getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: colors.key,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: AppTextStyles.labelSm(context).copyWith(color: colors.value),
      ),
    );
  }
}
