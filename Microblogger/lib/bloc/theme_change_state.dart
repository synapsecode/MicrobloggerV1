import 'package:MicroBlogger/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final bool isLightMode;
  final ThemeMode themeMode;
  const ThemeState(this.isLightMode, this.themeMode);
  factory ThemeState.light() {
    return ThemeState(true, ThemeMode.light);
  }
  factory ThemeState.dark() {
    return ThemeState(false, ThemeMode.dark);
  }
  @override
  List<Object> get props => [isLightMode, themeMode];
}

abstract class ThemeChangeState extends Equatable {
  final ThemeState themeState;
  ThemeChangeState(this.themeState);
  @override
  List<Object> get props => [themeState];
}

class LightThemeState extends ThemeChangeState {
  static final state = ThemeState.light();
  LightThemeState() : super(state);
}

class DarkThemeState extends ThemeChangeState {
  static final state = ThemeState.dark();
  DarkThemeState() : super(state);
}
