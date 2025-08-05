import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTitleContentsText extends StatelessWidget {
  final String title;
  final String contents;
  const AppTitleContentsText({
    super.key,
    required this.title,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(title, style: AppTextStyles.title(context)),
        SizedBox(height: 4.0),
        SelectableText(contents, style: AppTextStyles.label(context)),
      ],
    );
  }
}
