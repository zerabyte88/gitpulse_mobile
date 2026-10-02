import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConfig {
  static const String appName = 'GitPulse';
  static const String appVersion = 'v1.0.4';
  static const String buildNumber = '5';
  static const String fullVersion = 'v1.0.4 (Build 5)';
  static const String releaseTag = 'v1.0.4';
  static const String githubRepoUrl = 'https://github.com/zerabyte88/gitpulse_mobile';
  static const String developerUsername = 'zerabyte88';
  static const String developerGithubUrl = 'https://github.com/zerabyte88';
  static const String developerAvatarUrl = 'https://github.com/zerabyte88.png';
  static const String license = 'MIT License';
}

enum AppThemeMode {
  dark('dark'),
  amoled('amoled'),
  amoledJapanese('amoled_japanese'),
  light('light');

  final String key;
  const AppThemeMode(this.key);

  static AppThemeMode fromKey(String? key) {
    return AppThemeMode.values.firstWhere(
      (m) => m.key == key,
      orElse: () => AppThemeMode.dark,
    );
  }
}

class AppTheme {
  static AppThemeMode currentMode = AppThemeMode.dark;

  // Dynamic Backgrounds & Surfaces
  static Color get background => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF000000),
        AppThemeMode.amoledJapanese => const Color(0xFF000000),
        AppThemeMode.light => const Color(0xFFF6F8FA),
        AppThemeMode.dark => const Color(0xFF0E131F),
      };

  static Color get surface => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF0C0E12),
        AppThemeMode.amoledJapanese => const Color(0xFF0E0B14),
        AppThemeMode.light => const Color(0xFFFFFFFF),
        AppThemeMode.dark => const Color(0xFF151C2C),
      };

  static Color get surfaceElevated => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF161920),
        AppThemeMode.amoledJapanese => const Color(0xFF191322),
        AppThemeMode.light => const Color(0xFFEEF2F6),
        AppThemeMode.dark => const Color(0xFF1D263B),
      };

  static Color get border => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF222733),
        AppThemeMode.amoledJapanese => const Color(0xFF2D1F3D),
        AppThemeMode.light => const Color(0xFFD0D7DE),
        AppThemeMode.dark => const Color(0xFF2A364F),
      };

  static Color get borderSubtle => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF141720),
        AppThemeMode.amoledJapanese => const Color(0xFF1F152B),
        AppThemeMode.light => const Color(0xFFE6E8EB),
        AppThemeMode.dark => const Color(0xFF1F293D),
      };

  // Semantic Accents
  static Color get primaryCyan => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF00D2FF),
        AppThemeMode.amoledJapanese => const Color(0xFFFF7597), // Sakura Rose
        AppThemeMode.light => const Color(0xFF0969DA),
        AppThemeMode.dark => const Color(0xFF38BDF8),
      };

  static Color get primaryViolet => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFFB388FF),
        AppThemeMode.amoledJapanese => const Color(0xFFC084FC),
        AppThemeMode.light => const Color(0xFF8250DF),
        AppThemeMode.dark => const Color(0xFFA78BFA),
      };

  static Color get accentGreen => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF00E676),
        AppThemeMode.amoledJapanese => const Color(0xFF4ADE80),
        AppThemeMode.light => const Color(0xFF1A7F37),
        AppThemeMode.dark => const Color(0xFF34D399),
      };

  static Color get accentAmber => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFFFFD54F),
        AppThemeMode.amoledJapanese => const Color(0xFFFCD34D),
        AppThemeMode.light => const Color(0xFF9A6700),
        AppThemeMode.dark => const Color(0xFFFBBF24),
      };

  static Color get accentRed => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFFFF5252),
        AppThemeMode.amoledJapanese => const Color(0xFFFB7185),
        AppThemeMode.light => const Color(0xFFCF222E),
        AppThemeMode.dark => const Color(0xFFF87171),
      };

  static Color get accentOrange => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFFFF9100),
        AppThemeMode.amoledJapanese => const Color(0xFFFB923C),
        AppThemeMode.light => const Color(0xFFBC4C00),
        AppThemeMode.dark => const Color(0xFFFB923C),
      };

  // Typography Monochromatic Hierarchy
  static Color get textPrimary => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFFF8FAFC),
        AppThemeMode.amoledJapanese => const Color(0xFFFFF1F5),
        AppThemeMode.light => const Color(0xFF1F2328),
        AppThemeMode.dark => const Color(0xFFF1F5F9),
      };

  static Color get textSecondary => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF94A3B8),
        AppThemeMode.amoledJapanese => const Color(0xFFD1BEDA),
        AppThemeMode.light => const Color(0xFF656D76),
        AppThemeMode.dark => const Color(0xFF94A3B8),
      };

  static Color get textMuted => switch (currentMode) {
        AppThemeMode.amoled => const Color(0xFF64748B),
        AppThemeMode.amoledJapanese => const Color(0xFF8D7B9A),
        AppThemeMode.light => const Color(0xFF8C959F),
        AppThemeMode.dark => const Color(0xFF64748B),
      };

  static bool get isLight => currentMode == AppThemeMode.light;

  static ThemeData get currentThemeData => getTheme(currentMode);
  static ThemeData get darkTheme => getTheme(AppThemeMode.dark);

  static ThemeData getTheme(AppThemeMode mode) {
    final isLightMode = mode == AppThemeMode.light;
    final baseTextTheme = isLightMode
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    final bg = switch (mode) {
      AppThemeMode.amoled => const Color(0xFF000000),
      AppThemeMode.amoledJapanese => const Color(0xFF000000),
      AppThemeMode.light => const Color(0xFFF6F8FA),
      AppThemeMode.dark => const Color(0xFF0E131F),
    };

    final surf = switch (mode) {
      AppThemeMode.amoled => const Color(0xFF0C0E12),
      AppThemeMode.amoledJapanese => const Color(0xFF0E0B14),
      AppThemeMode.light => const Color(0xFFFFFFFF),
      AppThemeMode.dark => const Color(0xFF151C2C),
    };

    final brd = switch (mode) {
      AppThemeMode.amoled => const Color(0xFF222733),
      AppThemeMode.amoledJapanese => const Color(0xFF2D1F3D),
      AppThemeMode.light => const Color(0xFFD0D7DE),
      AppThemeMode.dark => const Color(0xFF2A364F),
    };

    final prim = switch (mode) {
      AppThemeMode.amoled => const Color(0xFF00D2FF),
      AppThemeMode.amoledJapanese => const Color(0xFFFF7597),
      AppThemeMode.light => const Color(0xFF0969DA),
      AppThemeMode.dark => const Color(0xFF38BDF8),
    };

    final sec = switch (mode) {
      AppThemeMode.amoled => const Color(0xFFB388FF),
      AppThemeMode.amoledJapanese => const Color(0xFFC084FC),
      AppThemeMode.light => const Color(0xFF8250DF),
      AppThemeMode.dark => const Color(0xFFA78BFA),
    };

    final txtPrim = switch (mode) {
      AppThemeMode.amoled => const Color(0xFFF8FAFC),
      AppThemeMode.amoledJapanese => const Color(0xFFFFF1F5),
      AppThemeMode.light => const Color(0xFF1F2328),
      AppThemeMode.dark => const Color(0xFFF1F5F9),
    };

    final txtMuted = switch (mode) {
      AppThemeMode.amoled => const Color(0xFF64748B),
      AppThemeMode.amoledJapanese => const Color(0xFF8D7B9A),
      AppThemeMode.light => const Color(0xFF8C959F),
      AppThemeMode.dark => const Color(0xFF64748B),
    };

    final interTheme = GoogleFonts.interTextTheme(baseTextTheme).apply(
      bodyColor: txtPrim,
      displayColor: txtPrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isLightMode ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: prim,
      colorScheme: isLightMode
          ? ColorScheme.light(
              primary: prim,
              secondary: sec,
              surface: surf,
              onSurface: txtPrim,
              error: const Color(0xFFCF222E),
            )
          : ColorScheme.dark(
              primary: prim,
              secondary: sec,
              surface: surf,
              onSurface: txtPrim,
              error: const Color(0xFFF85149),
            ),
      textTheme: interTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: txtPrim),
        titleTextStyle: TextStyle(
          color: txtPrim,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surf,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: brd, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surf,
        hintStyle: TextStyle(color: txtMuted, fontSize: 13.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: brd, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: brd, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: prim, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: prim,
          foregroundColor: isLightMode ? Colors.white : const Color(0xFF0D1117),
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
      dividerTheme: DividerThemeData(
        color: brd,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
