import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class AppBoxContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const AppBoxContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.shadowMargin),
      decoration: AppUIStyles.shadowBoxDecoration,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.appPadding / 2),

            child: Text(title, style: AppTextStyles.title(context)),
          ),
          Divider(indent: 0.0, endIndent: 0.0, height: 4.0, thickness: 1.0),
          Padding(
            padding: const EdgeInsets.all(AppSizes.appPadding / 2),
            child: child,
          ),
        ],
      ),
    );
  }
}
