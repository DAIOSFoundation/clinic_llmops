import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class FileCardWidget extends StatelessWidget {
  final String name;
  const FileCardWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: [
          Image.asset(
            AppUIStyles.getFileIcon(name),
            width: AppSizes.sidebarIconSize,
            height: AppSizes.sidebarIconSize,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.label(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
