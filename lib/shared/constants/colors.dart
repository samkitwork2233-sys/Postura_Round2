import 'package:flutter/material.dart';

/// App-wide color constants following Shadcn UI naming conventions.
/// 
/// We have 2 major themes (Light/Dark) and 2 minor themes (Safe/Alert).
class AppColors {
  // --- BASE COLORS ---

  // Light Theme (Warm)
  static const backgroundLight = Color(0xFFF4FBF9);
  static const foregroundLight = Color(0xFF090D10);
  
  // Dark Theme (Deep Slate)
  static const backgroundDark = Color(0xFF0D171C);
  static const foregroundDark = Color(0xFFFAFAF9);

  // --- FEATURE COLORS (Safe/Alert) ---

  // Safe (Luminous Teal)
  static const safeLight = Color(0xFF0D9488); 
  static const safeDark = Color(0xFF2DD4BF);  

  // Alert (Amber)
  static const alertLight = Color(0xFFD97706); // Darker amber for contrast on light
  static const alertDark = Color(0xFFF59E0B);  // Brighter amber for dark mode

  // --- SHADCN VARIABLES MAP ---

  // Common UI Colors (Zinc/Gray shades)
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF09090B);

  static const popoverLight = Color(0xFFFFFFFF);
  static const popoverDark = Color(0xFF09090B);

  static const primaryLight = Color(0xFF18181B);
  static const primaryDark = Color(0xFFFAFAF9);

  static const secondaryLight = Color(0xFFF4F4F5);
  static const secondaryDark = Color(0xFF27272A);

  static const mutedLight = Color(0xFFF4F4F5);
  static const mutedDark = Color(0xFF27272A);

  static const accentLight = Color(0xFFF4F4F5);
  static const accentDark = Color(0xFF27272A);

  static const borderLight = Color(0xFFE4E4E7);
  static const borderDark = Color(0xFF27272A);

  static const inputLight = Color(0xFFE4E4E7);
  static const inputDark = Color(0xFF27272A);

  static const ringLight = Color(0xFF18181B);
  static const ringDark = Color(0xFFD4D4D8);

  // Text variations
  static const mutedForegroundLight = Color(0xFF71717A);
  static const mutedForegroundDark = Color(0xFFA1A1AA);

  // Destructive (Red)
  static const destructive = Color(0xFFEF4444);
  
  // Azure (Light Blue / Cyan mix)
  static const azure = Color(0xFF0EA5E9); 
}
