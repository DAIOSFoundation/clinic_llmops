import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';

const double kDesktopMaxWidth = double.infinity;

class AppDefaultLayout extends StatelessWidget {
  final Widget child;
  final Widget? sidebar;
  final Widget? drawer;
  final Color backgroundColor;
  final double horizontalPadding;
  final double maxWidth;
  final double sidebarWidth;

  const AppDefaultLayout({
    super.key,
    required this.child,
    this.sidebar,
    this.drawer,
    this.backgroundColor = AppColors.white,
    this.horizontalPadding = AppSizes.appPadding,
    this.maxWidth = kDesktopMaxWidth,
    this.sidebarWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildResponsiveBody(context),
      drawer: drawer,
    );
  }

  Widget _buildResponsiveBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget mainContent = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        );

        if (!AppResponsiveWidget.isTablet(context)) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sidebar != null)
                Container(
                  width: sidebarWidth,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepGrey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(2, 0),
                      ),
                    ],
                  ),
                  child: sidebar!,
                ),
              Expanded(child: mainContent),
            ],
          );
        } else {
          return mainContent;
        }
      },
    );
  }
}
