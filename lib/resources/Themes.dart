import 'package:espn/resources/Colors.dart';
import 'package:flutter/material.dart';

/// Theme config is responsible for assigning the proper theme for the app.
class ThemeConfig {
  static ThemeData obtain() {
    return _darkTheme;
  }

  static ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        brightness: Brightness.dark, color: DarkThemeColors.bgPrimary),
    accentColor: DarkThemeColors.colorAccent,
    accentColorBrightness: Brightness.dark,
    textSelectionColor: DarkThemeColors.textPrimary,
  );
}
