import 'package:flutter/material.dart';
import '../localization/app_language.dart';
import '../localization/app_localizations.dart';
import 'storage_service.dart';

class AppLanguageService {
  static late final ValueNotifier<AppLanguage> currentLanguageNotifier;

  static void init(StorageService storageService) {
    final code = storageService.getLanguageCode();
    final lang = AppLanguage.fromCode(code);
    currentLanguageNotifier = ValueNotifier<AppLanguage>(lang);
    AppLocalizations(lang);
  }

  static AppLanguage get currentLanguage => currentLanguageNotifier.value;

  static Future<void> changeLanguage(
    AppLanguage language,
    StorageService storageService,
  ) async {
    await storageService.setLanguageCode(language.code);
    currentLanguageNotifier.value = language;
  }
}
