import 'package:flutter/material.dart';

Map CurrentPalette = darkThemePalette; //Default Dark Theme
ThemeData CurrentTheme = CustomDarkThemeData;

final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
);

Color primaryColor = Color(0xFF6990AF);
Color secondaryColor = Color(0xFF73AFB0);
Color background = Color(0xFF0D1520);

//Real Implementable Colors
Map<String, dynamic> darkThemePalette = {
  "primaryBackgroundColor": const Color(0xFF0D1520),
  "secondaryBackgroundColor": const Color(0xFF121A26),
  "errorColor": const Color(0xFFB00020),
  "postBackgroundColor": const Color(0xFFFFFFFF),
  "postcolour": Color.fromARGB(255, 28, 28, 28), //black12,
  "childpostcolour": Color.fromARGB(255, 32, 32, 32), //black12 (overlay)
  "sheetcolor": Color.fromARGB(255, 32, 32, 32),
  "border": Colors.white30, //black38
  "transparent_text": Colors.white30, //black26
  "cardbackground": Colors.black12, //white10
  "solidconjugate": Colors.black, //white
};
Map<String, dynamic> lightThemePalette = {
  "primaryBackgroundColor": const Color(0xFF0D1520),
  "secondaryBackgroundColor": const Color(0xFF121A26),
  "errorColor": const Color(0xFFB00020),
  "postBackgroundColor": const Color(0xFFFFFFFF),
  "postcolour": Colors.white, //black12,
  "childpostcolour": Colors.black12, //black12 (overlay)
  "sheetcolor": Color.fromARGB(255, 32, 32, 32),
  "border": Colors.black45, //black38
  "transparent_text": Colors.black45, //black26
  "cardbackground": Colors.black12, //white10
  "solidconjugate": Colors.black, //white
};

final ThemeData CustomDarkThemeData = ThemeData(
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
  // appBarTheme: AppBarTheme(
  //   color: const Color(0xFF0D1520),
  //   brightness: Brightness.dark,
  //   iconTheme: IconThemeData(color: Colors.white),
  //   actionsIconTheme: IconThemeData(color: Colors.white),
  // ),
);

final ThemeData CustomLightThemeData = ThemeData(
  brightness: Brightness.light,
  accentColorBrightness: Brightness.light,
  primaryColor: primaryColor,
  cardColor: Color(0xFFFFFFFF),
  primaryColorDark: const Color(0xFF0050a0),
  primaryColorLight: secondaryColor,
  buttonColor: primaryColor,
  indicatorColor: Colors.white,
  toggleableActiveColor: secondaryColor,
  accentColor: secondaryColor,
  canvasColor: const Color(0xFF2A4058),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  backgroundColor: const Color(0xFFFFFFFF),
  errorColor: const Color(0xFFB00020),
  buttonTheme: ButtonThemeData(
    colorScheme: colorScheme,
    textTheme: ButtonTextTheme.primary,
  ),
  // appBarTheme: AppBarTheme(
  //   color: const Color(0xFFFFFFFF),
  //   brightness: Brightness.light,
  //   iconTheme: IconThemeData(color: Colors.black38),
  //   actionsIconTheme: IconThemeData(color: Colors.black38),
  // ),
);
