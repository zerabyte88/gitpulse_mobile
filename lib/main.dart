import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/github_api_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();
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
    return MaterialApp(
      title: 'GitPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: HomeScreen(
        storageService: storageService,
        apiService: apiService,
      ),
    );
  }
}
