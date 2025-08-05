import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'NotoSansKR';

  static double _getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    const double referenceWidth = 1280.0;
    final double screenWidth = MediaQuery.of(context).size.width;

    double scaleFactor = screenWidth / referenceWidth;

    const double minScaleFactor = 0.95;
    const double maxScaleFactor = 1.05;

    scaleFactor = scaleFactor.clamp(minScaleFactor, maxScaleFactor);

    return baseFontSize * scaleFactor;
  }

  static TextStyle bodyLg(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 17),
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle body(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 15),
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle bodySm(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 13),
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle labelLg(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 14),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle label(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 13),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle labelSm(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 10),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleLg(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 32),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 15),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleSm(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 13),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle h1(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 44),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle h2(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 32),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle h3(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 24),
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle h4(BuildContext context) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _getResponsiveFontSize(context, 20),
      fontWeight: FontWeight.w700,
    );
  }

  // static TextStyle bodyLg(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 16),
  //     fontWeight: FontWeight.w300,
  //   );
  // }
  //
  // static TextStyle body(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 14),
  //     fontWeight: FontWeight.w300,
  //   );
  // }
  //
  // static TextStyle bodySm(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 11),
  //     fontWeight: FontWeight.w300,
  //   );
  // }
  //
  // static TextStyle labelLg(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 16),
  //     fontWeight: FontWeight.w500,
  //   );
  // }
  //
  // static TextStyle label(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 14),
  //     fontWeight: FontWeight.w500,
  //   );
  // }
  //
  // static TextStyle labelSm(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 13),
  //     fontWeight: FontWeight.w500,
  //   );
  // }
  //
  // static TextStyle titleLg(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 36),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle title(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 16),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle titleSm(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 14),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle h1(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 36),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle h2(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 30),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle h3(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 24),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
  //
  // static TextStyle h4(BuildContext context) {
  //   return TextStyle(
  //     fontFamily: fontFamily,
  //     fontSize: _getResponsiveFontSize(context, 18),
  //     fontWeight: FontWeight.w700,
  //   );
  // }
}
