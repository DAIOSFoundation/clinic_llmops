import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);
}
