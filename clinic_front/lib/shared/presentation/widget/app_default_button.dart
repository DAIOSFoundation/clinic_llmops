import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppDefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Widget? child;
  final EdgeInsets padding;
  final IconData? icon;
  final Color color;
  final Color fontColor;
  final bool isDisable;
  final double? height;
  final double? width;

  const AppDefaultButton({
    super.key,
    this.onPressed,
    required this.title,
    this.child,
    this.icon,
    this.color = AppColors.black,
    this.fontColor = AppColors.white,
    this.padding = const EdgeInsets.all(0.0),
    this.isDisable = false,
    this.height = 32.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveOnPressed = isDisable ? null : onPressed;

    final Color effectiveColor =
        isDisable ? AppColors.grey.withValues(alpha: 0.4) : color;

    final Color effectiveFontColor =
        isDisable ? AppColors.deepGrey.withValues(alpha: .5) : fontColor;

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: effectiveOnPressed,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(10.0),
            border:
                color == AppColors.white
                    ? Border.all(width: 0.5, color: AppColors.grey)
                    : null,
          ),
          child: Row(
            mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: effectiveFontColor),
                const SizedBox(width: 8),
              ],
              child != null
                  ? child!
                  : Text(
                    title,
                    style: AppTextStyles.labelSm(
                      context,
                    ).copyWith(color: effectiveFontColor),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
