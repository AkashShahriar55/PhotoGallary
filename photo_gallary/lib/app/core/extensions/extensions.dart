import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}