import 'package:MicroBlogger/theme.dart';
import 'package:flutter/material.dart';

Map CurrentPalette = darkThemePalette; //Default Dark Theme

final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
);

final ThemeData base = ThemeData(
  brightness: Brightness.dark,
  accentColorBrightness: Brightness.dark,
  primaryColor: primaryColor,
  cardColor: Color(0xFF121A26),
  primaryColorDark: const Color(0xFF0050a0),
  primaryColorLight: secondaryColor,
  buttonColor: primaryColor,
  indicatorColor: Colors.white,
  toggleableActiveColor: secondaryColor,
  accentColor: secondaryColor,
  canvasColor: const Color(0xFF2A4058),
  scaffoldBackgroundColor: const Color(0xFF121A26),
  backgroundColor: const Color(0xFF0D1520),
  errorColor: const Color(0xFFB00020),
  buttonTheme: ButtonThemeData(
    colorScheme: colorScheme,
    textTheme: ButtonTextTheme.primary,
  ),
);

//Real Implementable Colors
Map<String, dynamic> darkThemePalette = {
  "primaryBackgroundColor": const Color(0xFF0D1520),
  "secondaryBackgroundColor": const Color(0xFF121A26),
  "errorColor": const Color(0xFFB00020),
  "postBackgroundColor": const Color(0xFFFFFFFF)
};

//MaterialThemeData
final ThemeData CustomDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  accentColorBrightness: Brightness.dark,
  errorColor: darkThemePalette['errorColor'],
  cardColor: Color(0xFF121A26),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme.dark(),
    textTheme: ButtonTextTheme.primary,
  ),
  scaffoldBackgroundColor: darkThemePalette['secondaryBackgroundColor'],
);

Map<String, dynamic> lightTheme = {};
