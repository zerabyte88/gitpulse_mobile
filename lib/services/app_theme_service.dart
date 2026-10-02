import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'storage_service.dart';

class AppThemeService {
  static final ValueNotifier<AppThemeMode> currentThemeNotifier =
      ValueNotifier<AppThemeMode>(AppThemeMode.dark);

  static AppThemeMode get currentTheme => currentThemeNotifier.value;

  static void init(StorageService storageService) {
    final savedKey = storageService.getThemeMode();
    final mode = AppThemeMode.fromKey(savedKey);
    AppTheme.currentMode = mode;
    currentThemeNotifier.value = mode;
  }

  static Future<void> changeTheme(
    AppThemeMode mode,
    StorageService storageService,
  ) async {
    AppTheme.currentMode = mode;
    currentThemeNotifier.value = mode;
    await storageService.setThemeMode(mode.key);
  }

  static bool isJapaneseUnlocked(StorageService storageService) {
    return storageService.isJapaneseThemeUnlocked();
  }

  static Future<void> unlockJapaneseTheme(StorageService storageService) async {
    await storageService.setJapaneseThemeUnlocked(true);
  }
}
