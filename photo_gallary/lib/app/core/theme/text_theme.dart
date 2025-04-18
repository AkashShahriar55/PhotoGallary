import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';



TextTheme createTextTheme(
    String fontString,{
      String? titleFontString,
      String? bodyFontString,
      String? displayFontString
    }) {
  // Set default values for bodyFontString and displayFontString if they are not provided.
  bodyFontString ??= fontString;
  displayFontString ??= fontString;
  titleFontString ??= fontString;

  // Apply the body font string using Google Fonts
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString);

  // Apply the display font string using Google Fonts
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString);

  // Apply the display font string using Google Fonts
  TextTheme titleTextTheme = GoogleFonts.getTextTheme(titleFontString);


  TextTheme textTheme = TextTheme(
    bodyMedium: bodyTextTheme.bodyMedium?.copyWith(
      fontSize: Dimens.dimen_20,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: bodyTextTheme.labelLarge?.copyWith(
      fontSize: Dimens.dimen_21,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: bodyTextTheme.labelMedium?.copyWith(
      fontSize: Dimens.dimen_16,
      fontWeight: FontWeight.w500,
    ),
    displaySmall: displayTextTheme.displaySmall?.copyWith(
      fontSize: Dimens.dimen_14,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: titleTextTheme.titleLarge?.copyWith(
      fontSize: Dimens.dimen_20,
      fontWeight: FontWeight.w400,
    ),
  );
  return textTheme;
}
