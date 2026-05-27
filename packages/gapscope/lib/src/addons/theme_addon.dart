import 'package:flutter/material.dart';
import '../models/addon_state.dart';
import 'gapscope_addon.dart';

/// Theme addon state model
class ThemeAddonState extends AddonState {
  final ThemeMode themeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const ThemeAddonState({
    super.enabled = true,
    this.themeMode = ThemeMode.system,
    this.lightTheme,
    this.darkTheme,
  });

  ThemeAddonState copyWith({
    bool? enabled,
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeAddonState(
      enabled: enabled ?? this.enabled,
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeAddonState &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          themeMode == other.themeMode;

  @override
  int get hashCode => Object.hash(enabled, themeMode);
}

/// Theme addon for switching between light/dark themes
class ThemeAddon extends GapScopeAddon<ThemeAddonState> {
  @override
  String get id => 'theme_addon';

  @override
  String get name => 'Theme Switcher';

  @override
  String? get description => 'Switch between light and dark themes';

  @override
  final ThemeAddonState state;

  static ThemeData defaultLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData defaultDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  );

  ThemeAddon({
    this.state = const ThemeAddonState(),
  });

  @override
  ThemeAddonState updateState(ThemeAddonState state) {
    return state;
  }

  ThemeAddon copyWith(ThemeAddonState? state) {
    return ThemeAddon(
      state: state ?? this.state,
    );
  }
}