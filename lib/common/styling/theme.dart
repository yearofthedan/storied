import 'package:flutter/material.dart';

class ThemeConfig {
  late final ThemeData dark;
  late final ThemeData light;

  static const text = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Raleway'),
    displayMedium: TextStyle(fontFamily: 'Raleway'),
    displaySmall: TextStyle(fontFamily: 'Raleway'),
    headlineLarge: TextStyle(fontFamily: 'Raleway'),
    headlineMedium: TextStyle(fontFamily: 'Raleway'),
    headlineSmall: TextStyle(fontFamily: 'Raleway'),
  );

  static var defaultLightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
    error: Colors.red,
  );

  static var defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
    error: Colors.red,
  );

  ThemeConfig.fromDeviceSchemes(
      ColorScheme? lightScheme, ColorScheme? darkScheme)
      : light = _getTheme(lightScheme, defaultLightColorScheme),
        dark = _getTheme(darkScheme, defaultDarkColorScheme);

  static _getTheme(ColorScheme? colorScheme, ColorScheme fallbackScheme) {
    return ThemeData.from(
        colorScheme: colorScheme ?? fallbackScheme,
        textTheme: text,
        useMaterial3: true);
  }
}
