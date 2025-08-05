import 'package:banya_llmops/shared/constants/app_assets.dart';
import 'package:banya_llmops/shared/presentation/widget/app_default_button.dart';
import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/utils/extenstions/ui_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const double kDesktopMaxHeight = 70.0;

class ContentsLayout extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final String? buttonText;
  final Widget? headWidget;
  final Widget? child;
  final Widget? pannelWidget;
  final bool isBack;
  final bool isPadding;

  const ContentsLayout({
    super.key,
    required this.title,
    this.buttonText,
    this.headWidget,
    this.onPressed,
    this.child,
    this.pannelWidget,
    this.isBack = false,
    this.isPadding = true,
  });

  @override
  State<ContentsLayout> createState() => _ContentsLayoutState();
}

class _ContentsLayoutState extends State<ContentsLayout> {
  bool _isRightPannelVisible = true;

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 3, left: 3, right: 3),
          height: kDesktopMaxHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.deepGrey.withValues(alpha: 0.1),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  AppResponsiveWidget.isTablet(context)
                      ? AppSizes.spacing
                      : AppSizes.appPadding,
            ),
            child: Row(
              children: [
                if (widget.isBack)
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(true),
                        child: Image.asset(
                          AppAssets.ICON_LEFT_ARROW,
                          width: AppSizes.sidebarIconSize,
                          height: AppSizes.sidebarIconSize,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing),
                    ],
                  ),
                Text(widget.title, style: AppTextStyles.title(context)),
                if (widget.headWidget != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.appPadding / 2,
                    ),
                    child: Container(child: widget.headWidget),
                  ),
                const Spacer(),
                if (widget.buttonText != null && widget.onPressed != null)
                  AppDefaultButton(
                    onPressed: widget.onPressed!,
                    title: widget.buttonText!,
                  ),
                if (widget.pannelWidget != null) ...{
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: SizedBox(
                      height: AppSizes.spacing,
                      child: VerticalDivider(
                        thickness: 0.5,
                        color: AppColors.deepGrey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRightPannelVisible = !_isRightPannelVisible;
                      });
                    },
                    child: Image.asset(
                      AppAssets.ICON_SIDEBAR,
                      width: AppSizes.sidebarIconSize,
                      height: AppSizes.sidebarIconSize,
                    ),
                  ),
                },
              ],
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  widget.isPadding ? context.screenSize.width * 0.04 : 0,
              vertical:
                  widget.isPadding
                      ? AppResponsiveWidget.isTablet(context)
                          ? AppSizes.appPadding
                          : AppSizes.appPadding * 2
                      : 0,
            ),
            child: widget.child ?? SizedBox.shrink(),
          ),
        ),
      ],
    );

    return Row(
      children: [
        Expanded(child: mainContent),
        if (_isRightPannelVisible && widget.pannelWidget != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepGrey.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            width: context.screenSize.width * 0.25,
            height: context.screenSize.height,
            child: Padding(
              padding: EdgeInsets.only(
                right: context.screenSize.width * 0.02,
                left: context.screenSize.width * 0.02,
                top: AppSizes.appPadding,
                bottom: AppSizes.appPadding,
              ),
              child: widget.pannelWidget,
            ),
          ),
      ],
    );
  }
}
