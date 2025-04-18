import "package:flutter/material.dart";
import "package:photo_gallary/app/core/theme/text_theme.dart";
import "colors.dart";



class AppTheme {

  const AppTheme();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColors.primaryColor,
      onPrimary: ThemeColors.primaryFontColor,
      secondary: ThemeColors.secondaryColor,
      onSecondary: ThemeColors.secondaryFontColor,
      surface: ThemeColors.backgroundColor,
      onSurface: ThemeColors.primaryFontColor,
      onSurfaceVariant: ThemeColors.secondaryFontColor,
      onError: ThemeColors.fontColorWhite,
      error: ThemeColors.errorColor,
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: createTextTheme('Roboto').apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurfaceVariant,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );
}