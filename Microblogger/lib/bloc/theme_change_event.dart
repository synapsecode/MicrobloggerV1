import 'package:equatable/equatable.dart';

abstract class ThemeChangeEvent extends Equatable {}

class OnThemeChangedEvent extends ThemeChangeEvent {
  final bool lightMode;
  OnThemeChangedEvent(this.lightMode);
  @override
  List<Object> get props => [lightMode];
}
