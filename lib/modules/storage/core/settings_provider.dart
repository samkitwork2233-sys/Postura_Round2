import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

class SettingsState {
  final double threshold;
  final double vibrationDuration;
  final bool soundEnabled;
  final ThemeMode themeMode;
  final double minAngle;
  final double maxAngle;

  SettingsState({
    required this.threshold,
    required this.vibrationDuration,
    required this.soundEnabled,
    required this.themeMode,
    required this.minAngle,
    required this.maxAngle,
  });

  SettingsState copyWith({
    double? threshold,
    double? vibrationDuration,
    bool? soundEnabled,
    ThemeMode? themeMode,
    double? minAngle,
    double? maxAngle,
  }) {
    return SettingsState(
      threshold: threshold ?? this.threshold,
      vibrationDuration: vibrationDuration ?? this.vibrationDuration,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      themeMode: themeMode ?? this.themeMode,
      minAngle: minAngle ?? this.minAngle,
      maxAngle: maxAngle ?? this.maxAngle,
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
          minAngle: _service.minAngle,
          maxAngle: _service.maxAngle,
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

  Future<void> setMinAngle(double value) async {
    await _service.setMinAngle(value);
    state = state.copyWith(minAngle: value);
  }

  Future<void> setMaxAngle(double value) async {
    await _service.setMaxAngle(value);
    state = state.copyWith(maxAngle: value);
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return SettingsNotifier(service);
});
