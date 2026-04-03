import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

class SettingsState {
  final double threshold;
  final double vibrationDuration;
  final bool soundEnabled;
  final ThemeMode themeMode;
  final bool hasConnectedOnce;

  SettingsState({
    required this.threshold,
    required this.vibrationDuration,
    required this.soundEnabled,
    required this.themeMode,
    required this.hasConnectedOnce,
  });

  SettingsState copyWith({
    double? threshold,
    double? vibrationDuration,
    bool? soundEnabled,
    ThemeMode? themeMode,
    bool? hasConnectedOnce,
  }) {
    return SettingsState(
      threshold: threshold ?? this.threshold,
      vibrationDuration: vibrationDuration ?? this.vibrationDuration,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      themeMode: themeMode ?? this.themeMode,
      hasConnectedOnce: hasConnectedOnce ?? this.hasConnectedOnce,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsService _service;

  SettingsNotifier(this._service)
      : super(SettingsState(
          threshold: _service.threshold,
          vibrationDuration: _service.vibrationDuration,
          soundEnabled: _service.soundEnabled,
          themeMode: _parseThemeMode(_service.themeMode),
          hasConnectedOnce: _service.hasConnectedOnce,
        ));

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }

  Future<void> setThreshold(double value) async {
    await _service.setThreshold(value);
    state = state.copyWith(threshold: value);
  }

  Future<void> setVibrationDuration(double value) async {
    await _service.setVibrationDuration(value);
    state = state.copyWith(vibrationDuration: value);
  }

  Future<void> setSoundEnabled(bool value) async {
    await _service.setSoundEnabled(value);
    state = state.copyWith(soundEnabled: value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setThemeMode(_themeModeToString(mode));
    state = state.copyWith(themeMode: mode);
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> setHasConnectedOnce(bool value) async {
    await _service.setHasConnectedOnce(value);
    state = state.copyWith(hasConnectedOnce: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return SettingsNotifier(service);
});
