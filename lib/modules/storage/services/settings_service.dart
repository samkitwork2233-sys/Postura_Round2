import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsService {
  static const String keyThreshold = "threshold";
  static const String keyVibrationDuration = "vibration_duration";
  static const String keySoundEnabled = "sound_enabled";
  static const String keyThemeMode = "theme_mode";
  static const String keyHasConnectedOnce = "has_connected_once";

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  double get threshold => _prefs.getDouble(keyThreshold) ?? 15.0;
  Future<void> setThreshold(double value) => _prefs.setDouble(keyThreshold, value);

  double get vibrationDuration => _prefs.getDouble(keyVibrationDuration) ?? 500.0;
  Future<void> setVibrationDuration(double value) => _prefs.setDouble(keyVibrationDuration, value);

  bool get soundEnabled => _prefs.getBool(keySoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool value) => _prefs.setBool(keySoundEnabled, value);

  String get themeMode => _prefs.getString(keyThemeMode) ?? "system";
  Future<void> setThemeMode(String value) => _prefs.setString(keyThemeMode, value);

  bool get hasConnectedOnce => _prefs.getBool(keyHasConnectedOnce) ?? false;
  Future<void> setHasConnectedOnce(bool value) => _prefs.setBool(keyHasConnectedOnce, value);
}

final settingsServiceProvider = Provider<SettingsService>((ref) => throw UnimplementedError());
