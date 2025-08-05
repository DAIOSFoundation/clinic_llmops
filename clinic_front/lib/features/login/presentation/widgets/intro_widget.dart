import 'package:banya_llmops/shared/constants/app_assets.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      height: double.infinity,
      child: Image.asset(AppAssets.IMAGE_LOGO),
    );
  }
}
