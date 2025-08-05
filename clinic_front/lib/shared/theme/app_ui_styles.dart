import 'package:banya_llmops/shared/constants/app_assets.dart';
import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class AppUIStyles {
  AppUIStyles._();

  static BoxDecoration shadowBoxDecoration = BoxDecoration(
    color: AppColors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(AppSizes.borderRadius),

    border: Border.all(color: AppColors.lightGrey, width: 1.0),

    boxShadow: [
      BoxShadow(
        color: AppColors.deepGrey.withValues(alpha: 0.2),
        blurRadius: 1.0,
        offset: Offset(0, 1),
        spreadRadius: 1.0,
      ),
    ],
  );

  static BoxDecoration roundBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.grey, width: 1.0),
  );

  static MapEntry<Color, Color> getStatusColors(String status) {
    switch (status) {
      case 'Ready':
        return MapEntry(AppColors.readyColor, AppColors.readyTextColor);
      case 'Stay':
        return MapEntry(AppColors.stayColor, AppColors.stayTextColor);
      case 'Running':
        return MapEntry(AppColors.runningColor, AppColors.runningTextColor);
      case 'Completed':
      case 'Trained':
        return MapEntry(AppColors.lightBlue, AppColors.blue);
      case 'Failed':
        return MapEntry(AppColors.failedColor, AppColors.failedTextColor);
      default:
        return MapEntry(AppColors.defaultBgColor, AppColors.defaultTextColor);
    }
  }

  static String getFileIcon(String fileName) {
    final ext = p.extension(fileName).replaceFirst('.', '').toLowerCase();
    return switch (ext) {
      'doc' || 'docx' => AppAssets.ICON_DOC,
      'pdf' => AppAssets.ICON_PDF,
      'html' => AppAssets.ICON_CODE,
      _ => AppAssets.ICON_DOC,
    };
  }

  static double getAspectRatio(context) {
    final screenType = ScreenType.of(context);
    return switch (screenType) {
      ScreenType.mobile => 1.5,
      ScreenType.tablet => 1.1,
      ScreenType.desktop => 1.2,
    };
  }

  static int getMaxLine(context) {
    final screenType = ScreenType.of(context);
    return switch (screenType) {
      ScreenType.mobile => 8,
      ScreenType.tablet => 9,
      ScreenType.desktop => 11,
    };
  }
}
