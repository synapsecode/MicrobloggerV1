import 'package:MicroBlogger/bloc/theme_change_event.dart';
import 'package:MicroBlogger/bloc/theme_change_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../theme.dart';

class ThemeChangeBloc extends HydratedBloc<ThemeChangeEvent, ThemeChangeState> {
  @override
  ThemeChangeState get initialState => super.initialState ?? LightThemeState();

  @override
  ThemeChangeState fromJson(Map<String, dynamic> json) {
    bool isLightMode = json["isLightMode"] as bool;
    if (isLightMode) {
      applyPaletteChanges("LIGHT");
      return LightThemeState();
    } else {
      applyPaletteChanges("DARK");
      return DarkThemeState();
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeChangeState state) {
    return {"isLightMode": state.themeState.isLightMode};
  }

  @override
  Stream<ThemeChangeState> mapEventToState(ThemeChangeEvent event) async* {
    if (event is OnThemeChangedEvent) {
      yield* _onChangedTheme(event.lightMode);
    }
  }

  Stream<ThemeChangeState> _onChangedTheme(bool lightMode) async* {
    print("Changed");
    if (lightMode) {
      applyPaletteChanges("LIGHT");
      yield LightThemeState();
    } else {
      applyPaletteChanges("DARK");
      yield DarkThemeState();
    }
  }
}
