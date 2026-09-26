import 'package:flutter_test/flutter_test.dart';
import 'package:gitpulse_mobile/models/github_repo.dart';
import 'package:gitpulse_mobile/models/github_user.dart';
import 'package:gitpulse_mobile/models/user_stats.dart';

void main() {
  group('GitPulse Model Tests', () {
    test('GitHubUser fromJson parses correctly', () {
      final json = {
        'login': 'octocat',
        'id': 1,
        'avatar_url': 'https://github.com/images/error/octocat_happy.gif',
        'html_url': 'https://github.com/octocat',
        'name': 'The Octocat',
        'public_repos': 8,
        'followers': 20,
        'following': 0,
      };

      final user = GitHubUser.fromJson(json);

      expect(user.login, 'octocat');
      expect(user.id, 1);
      expect(user.publicRepos, 8);
      expect(user.followers, 20);
    });

    test('UserStats calculates stars and languages accurately', () {
      final user = GitHubUser(
        login: 'octocat',
        id: 1,
        avatarUrl: 'https://github.com/avatar.png',
        htmlUrl: 'https://github.com/octocat',
        publicRepos: 2,
        followers: 10,
        following: 2,
      );

      final repos = [
        GitHubRepo(
          name: 'repo1',
          htmlUrl: 'https://github.com/octocat/repo1',
          language: 'Dart',
          stargazersCount: 45,
          forksCount: 5,
          isFork: false,
        ),
        GitHubRepo(
          name: 'repo2',
          htmlUrl: 'https://github.com/octocat/repo2',
          language: 'Python',
          stargazersCount: 60,
          forksCount: 10,
          isFork: false,
        ),
      ];

      final stats = UserStats.calculate(
        user: user,
        repos: repos,
        publicEvents: [],
      );

      expect(stats.totalStars, 105);
      expect(stats.totalForks, 15);
      expect(stats.languageCounts['Dart'], 1);
      expect(stats.languageCounts['Python'], 1);
      expect(stats.developerPersona, contains('Star Magnet'));
    });
  });
}
