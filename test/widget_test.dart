import 'package:flutter_test/flutter_test.dart';
import 'package:gitpulse_mobile/models/contribution_stats.dart';
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

    test('ContributionStats determines commit titles correctly for different frequencies', () {
      // 1. Sangat Rajin Ekstrem (Mythic)
      final mythic = ContributionStats.determineTitle(
        currentStreak: 15,
        longestStreak: 35,
        thisYearContributions: 400,
        totalContributions: 600,
      );
      expect(mythic.title, contains('Code Titan'));
      expect(mythic.levelName, contains('Sangat Rajin'));

      // 2. Sangat Rajin (Diamond)
      final diamond = ContributionStats.determineTitle(
        currentStreak: 6,
        longestStreak: 15,
        thisYearContributions: 120,
        totalContributions: 200,
      );
      expect(diamond.title, contains('Relentless Committer'));
      expect(diamond.levelName, contains('Sangat Rajin'));

      // 3. Rajin & Stabil (Platinum)
      final platinum = ContributionStats.determineTitle(
        currentStreak: 3,
        longestStreak: 8,
        thisYearContributions: 45,
        totalContributions: 60,
      );
      expect(platinum.title, contains('Consistent Builder'));

      // 4. Terkadang Commit (Gold)
      final gold = ContributionStats.determineTitle(
        currentStreak: 1,
        longestStreak: 3,
        thisYearContributions: 15,
        totalContributions: 30,
      );
      expect(gold.title, contains('Weekend Warrior'));
      expect(gold.levelName, contains('Commit Terkadang'));

      // 5. Jarang Commit (Silver)
      final silver = ContributionStats.determineTitle(
        currentStreak: 0,
        longestStreak: 1,
        thisYearContributions: 3,
        totalContributions: 5,
      );
      expect(silver.title, contains('Dormant Explorer'));
      expect(silver.levelName, contains('Jarang Commit'));

      // 6. Belum Aktif (Bronze)
      final bronze = ContributionStats.determineTitle(
        currentStreak: 0,
        longestStreak: 0,
        thisYearContributions: 0,
        totalContributions: 0,
      );
      expect(bronze.title, contains('Fresh Sprout'));
      expect(bronze.levelName, contains('Belum Aktif'));
    });

    test('GitHubRepo relative time formatting handles hours and days', () {
      final now = DateTime.now();

      final recentRepo = GitHubRepo(
        name: 'recent-repo',
        htmlUrl: 'https://github.com/test/recent-repo',
        stargazersCount: 5,
        forksCount: 1,
        isFork: false,
        pushedAt: now.subtract(const Duration(hours: 3)),
      );
      expect(recentRepo.relativeTimeAgo, '3 jam lalu');
      expect(recentRepo.isRecentlyActive, true);

      final daysAgoRepo = GitHubRepo(
        name: 'days-repo',
        htmlUrl: 'https://github.com/test/days-repo',
        stargazersCount: 0,
        forksCount: 0,
        isFork: false,
        pushedAt: now.subtract(const Duration(days: 4)),
      );
      expect(daysAgoRepo.relativeTimeAgo, '4 hari lalu');
      expect(daysAgoRepo.isRecentlyActive, true);

      final oldRepo = GitHubRepo(
        name: 'old-repo',
        htmlUrl: 'https://github.com/test/old-repo',
        stargazersCount: 0,
        forksCount: 0,
        isFork: false,
        pushedAt: now.subtract(const Duration(days: 120)),
      );
      expect(oldRepo.relativeTimeAgo, '4 bln lalu');
      expect(oldRepo.isRecentlyActive, false);
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

      final contribStats = ContributionStats.determineTitle(
        currentStreak: 5,
        longestStreak: 10,
        thisYearContributions: 50,
        totalContributions: 100,
      );

      final stats = UserStats.calculate(
        user: user,
        repos: repos,
        publicEvents: [],
        contributionStats: ContributionStats(
          thisYearContributions: 50,
          lastYearContributions: 50,
          currentStreak: 5,
          longestStreak: 10,
          totalContributions: 100,
          commitTitle: contribStats,
          yearlyTotals: {'2026': 50, '2025': 50},
        ),
      );

      expect(stats.totalStars, 105);
      expect(stats.totalForks, 15);
      expect(stats.languageCounts['Dart'], 1);
      expect(stats.languageCounts['Python'], 1);
      expect(stats.developerPersona, contains('Star Magnet'));
    });

    test('UserStats uses aggregatedLanguages bytes with high fidelity', () {
      final user = GitHubUser(
        login: 'zerabyte88',
        id: 1,
        avatarUrl: 'https://github.com/avatar.png',
        htmlUrl: 'https://github.com/zerabyte88',
        publicRepos: 3,
        followers: 5,
        following: 1,
      );

      final repos = [
        GitHubRepo(
          name: 'repo1',
          htmlUrl: 'https://github.com/zerabyte88/repo1',
          language: 'Dart',
          stargazersCount: 0,
          forksCount: 0,
          isFork: false,
          size: 87,
        ),
      ];

      final aggregated = {
        'Dart': 66038,
        'HTML': 38404,
        'PHP': 210388,
        'CSS': 18771,
      };

      final contribStats = ContributionStats.determineTitle(
        currentStreak: 0,
        longestStreak: 0,
        thisYearContributions: 0,
        totalContributions: 0,
      );

      final stats = UserStats.calculate(
        user: user,
        repos: repos,
        publicEvents: [],
        contributionStats: ContributionStats(
          thisYearContributions: 0,
          lastYearContributions: 0,
          currentStreak: 0,
          longestStreak: 0,
          totalContributions: 0,
          commitTitle: contribStats,
          yearlyTotals: {},
        ),
        aggregatedLanguages: aggregated,
      );

      expect(stats.languageCounts['PHP'], 210388);
      expect(stats.languageCounts['Dart'], 66038);
      expect(stats.languageCounts['HTML'], 38404);
      expect(stats.languageCounts['CSS'], 18771);
    });
  });
}
