import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_language.dart';
import 'localization/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/app_language_service.dart';
import 'services/github_api_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();
  AppLanguageService.init(storageService);
  final apiService = GitHubApiService(
    personalAccessToken: storageService.getToken(),
  );

  runApp(GitPulseApp(
    storageService: storageService,
    apiService: apiService,
  ));
}

class GitPulseApp extends StatelessWidget {
  final StorageService storageService;
  final GitHubApiService apiService;

  const GitPulseApp({
    super.key,
    required this.storageService,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppLanguageService.currentLanguageNotifier,
      builder: (context, currentLang, _) {
        return MaterialApp(
          title: 'GitPulse',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: currentLang.locale,
          supportedLocales: AppLanguage.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeScreen(
            storageService: storageService,
            apiService: apiService,
          ),
        );
      },
    );
  }
}
