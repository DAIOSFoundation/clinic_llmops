import 'package:banya_llmops/shared/utils/extenstions/ui_extenstion.dart';
import 'package:flutter/widgets.dart';

enum ScreenType {
  mobile,
  tablet,
  desktop;

  static ScreenType of(BuildContext context) {
    final width = context.screenSize.width;
    if (width <= 600) {
      return ScreenType.mobile;
    } else if (width <= 900) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }
}

class AppResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width <= 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 900 &&
      MediaQuery.of(context).size.width <= 1280;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1280 &&
      MediaQuery.of(context).size.width <= 2200;

  static bool isExtraLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 2200;

  const AppResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });
  @override
  Widget build(BuildContext context) {
    return switch (ScreenType.of(context)) {
      ScreenType.mobile => mobile,
      ScreenType.tablet => tablet,
      ScreenType.desktop => desktop,
    };
  }
}
