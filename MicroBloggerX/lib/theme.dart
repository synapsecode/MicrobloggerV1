import 'package:flutter/material.dart';

Color primaryColor = Color(0xFF6990AF);
Color secondaryColor = Color(0xFF73AFB0);
Color background = Color(0xFF0D1520);

Map palette = {};

Map get getPalette => palette;

void setPalette(p) => palette = p;

final ThemeData lightTheme = buildLightTheme();
final ThemeData darkTheme = buildDarkTheme();
ThemeData buildLightTheme() {
  applyPaletteChanges("LIGHT");
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    toggleableActiveColor: secondaryColor,
    splashColor: Colors.white10,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  return base;
}

ThemeData buildDarkTheme() {
  applyPaletteChanges("DARK");
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
  return base;
}

void applyPaletteChanges(String mode) {
  if (mode == "LIGHT") {
    print("Using Light Theme");
    background = Colors.white;
    primaryColor = Color.fromARGB(255, 220, 20, 60);
    secondaryColor = Colors.black45;
    setPalette({
      "postcolour": Colors.black12, //black12,
      "childpostcolour": Colors.black12, //black12 (overlay)
      "border": Colors.black38, //black38
      "transparent_text": Colors.black26, //black26
      "cardbackground": Colors.white10, //white10
      "solidconjugate": Colors.black, //white
    });
  } else {
    print("Using Dark Theme");
    background = Color(0xFF0D1520);
    primaryColor = Color(0xFF0D1520);
    secondaryColor = Colors.black;
    setPalette({
      "postcolour": Color.fromARGB(255, 28, 28, 28), //black12,
      "childpostcolour": Color.fromARGB(255, 32, 32, 32), //black12 (overlay)
      "sheetcolor": Color.fromARGB(255, 32, 32, 32),
      "border": Colors.white30, //black38
      "transparent_text": Colors.white30, //black26
      "cardbackground": Colors.black12, //white10
      "solidconjugate": Colors.black, //white
    });
  }
}
