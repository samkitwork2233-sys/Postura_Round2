import 'package:flutter/material.dart';
import 'colors.dart';
import 'app_constants.dart';

/// App-wide theme definitions.
/// Handles 4 main variations: Light Safe, Light Alert, Dark Safe, Dark Alert.
class AppTheme {
  // --- HELPERS ---

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color foreground,
    required Color primary,
    required Color secondary,
    required Color muted,
    required Color mutedForeground,
    required Color accent,
    required Color border,
    required Color input,
    required Color card,
    required Color popover,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: brightness == Brightness.light ? Colors.white : Colors.black,
        secondary: secondary,
        onSecondary: foreground,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: card,
        onSurface: foreground,
        outline: border,
      ),
      cardTheme: CardThemeData(
        color: card,
        shadowColor: border,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: true,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primary,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
        ),
      ),
      // To follow Shadcn, we define input and other themes too
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }

  // --- LIGHT THEME VARIATIONS ---

  static ThemeData lightSafe() {
    return _buildTheme(
      brightness: Brightness.light,
      background: AppColors.backgroundLight,
      foreground: AppColors.foregroundLight,
      primary: AppColors.safeLight,
      secondary: AppColors.secondaryLight,
      muted: AppColors.mutedLight,
      mutedForeground: AppColors.mutedForegroundLight,
      accent: AppColors.accentLight,
      border: AppColors.borderLight,
      input: AppColors.inputLight,
      card: AppColors.cardLight,
      popover: AppColors.popoverLight,
    );
  }

  static ThemeData lightAlert() {
    return _buildTheme(
      brightness: Brightness.light,
      background: AppColors.backgroundLight,
      foreground: AppColors.foregroundLight,
      primary: AppColors.alertLight,
      secondary: AppColors.secondaryLight,
      muted: AppColors.mutedLight,
      mutedForeground: AppColors.mutedForegroundLight,
      accent: AppColors.accentLight,
      border: AppColors.borderLight,
      input: AppColors.inputLight,
      card: AppColors.cardLight,
      popover: AppColors.popoverLight,
    );
  }

  // --- DARK THEME VARIATIONS ---

  static ThemeData darkSafe() {
    return _buildTheme(
      brightness: Brightness.dark,
      background: AppColors.backgroundDark,
      foreground: AppColors.foregroundDark,
      primary: AppColors.safeDark,
      secondary: AppColors.secondaryDark,
      muted: AppColors.mutedDark,
      mutedForeground: AppColors.mutedForegroundDark,
      accent: AppColors.accentDark,
      border: AppColors.borderDark,
      input: AppColors.inputDark,
      card: AppColors.cardDark,
      popover: AppColors.popoverDark,
    );
  }

  static ThemeData darkAlert() {
    return _buildTheme(
      brightness: Brightness.dark,
      background: AppColors.backgroundDark,
      foreground: AppColors.foregroundDark,
      primary: AppColors.alertDark,
      secondary: AppColors.secondaryDark,
      muted: AppColors.mutedDark,
      mutedForeground: AppColors.mutedForegroundDark,
      accent: AppColors.accentDark,
      border: AppColors.borderDark,
      input: AppColors.inputDark,
      card: AppColors.cardDark,
      popover: AppColors.popoverDark,
    );
  }
}
