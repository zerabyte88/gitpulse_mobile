import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConfig {
  static const String appName = 'GitPulse';
  static const String appVersion = 'v1.0.1';
  static const String buildNumber = '2';
  static const String fullVersion = 'v1.0.1 (Build 2)';
  static const String releaseTag = 'v1.0.1';
  static const String githubRepoUrl = 'https://github.com/zerabyte88/gitpulse_mobile';
  static const String license = 'MIT License';
}

class AppTheme {
  // Brand Colors - Refined GitHub Dark / Linear Developer Slate Palette
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceElevated = Color(0xFF21262D);
  static const Color border = Color(0xFF30363D);
  static const Color borderSubtle = Color(0xFF21262D);

  // Semantic Accents (Refined & calm, replacing harsh neon cyberpunk colors)
  static const Color primaryCyan = Color(0xFF58A6FF); // GitHub Blue
  static const Color primaryViolet = Color(0xFFBC8CFF); // GitHub Purple
  static const Color accentGreen = Color(0xFF3FB950); // GitHub Contribution Green
  static const Color accentAmber = Color(0xFFD29922); // GitHub Star Amber / Gold
  static const Color accentRed = Color(0xFFF85149); // GitHub Coral Red
  static const Color accentOrange = Color(0xFFF0883E); // GitHub Issue Orange

  // High-legibility Monochromatic Neutral Text Hierarchy
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final interTheme = GoogleFonts.interTextTheme(baseTextTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryCyan,
      colorScheme: const ColorScheme.dark(
        primary: primaryCyan,
        secondary: primaryViolet,
        surface: surface,
        onSurface: textPrimary,
        error: accentRed,
      ),
      textTheme: interTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textMuted, fontSize: 13.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryCyan, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCyan,
          foregroundColor: const Color(0xFF0D1117),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
