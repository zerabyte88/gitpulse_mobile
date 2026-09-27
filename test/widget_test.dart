import 'package:flutter_test/flutter_test.dart';
import 'package:gitpulse_mobile/localization/app_language.dart';
import 'package:gitpulse_mobile/localization/app_localizations.dart';
import 'package:gitpulse_mobile/models/bookmarked_user.dart';
import 'package:gitpulse_mobile/models/contribution_stats.dart';
import 'package:gitpulse_mobile/models/github_rate_limit.dart';
import 'package:gitpulse_mobile/models/github_repo.dart';
import 'package:gitpulse_mobile/models/github_user.dart';
import 'package:gitpulse_mobile/models/tech_news.dart';
import 'package:gitpulse_mobile/models/user_stats.dart';
import 'package:gitpulse_mobile/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    test('BookmarkedUser parses correctly and provides avatar fallback', () {
      final userWithAvatar = BookmarkedUser.fromJson({
        'username': 'octocat',
        'avatar_url': 'https://avatars.githubusercontent.com/u/583231',
      });
      expect(userWithAvatar.username, 'octocat');
      expect(userWithAvatar.avatarUrl, 'https://avatars.githubusercontent.com/u/583231');

      final userDefault = BookmarkedUser.fromJson({
        'username': 'torvalds',
      });
      expect(userDefault.username, 'torvalds');
      expect(userDefault.avatarUrl, 'https://github.com/torvalds.png');
    });

    test('StorageService persists bookmarks with avatar and manages recent searches', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      // Add bookmark with custom avatar
      await storage.toggleBookmark('linus', avatarUrl: 'https://avatars.githubusercontent.com/linus');
      expect(storage.isBookmarked('linus'), true);

      final bookmarks = storage.getBookmarkedUsers();
      expect(bookmarks.length, 1);
      expect(bookmarks.first.username, 'linus');
      expect(bookmarks.first.avatarUrl, 'https://avatars.githubusercontent.com/linus');

      // Add recent searches and verify removal
      await storage.addRecentSearch('flutter');
      await storage.addRecentSearch('dart');
      expect(storage.getRecentSearches(), ['dart', 'flutter']);

      await storage.removeRecentSearch('dart');
      expect(storage.getRecentSearches(), ['flutter']);

      // Remove bookmark
      await storage.removeBookmark('linus');
      expect(storage.isBookmarked('linus'), false);
      expect(storage.getBookmarkedUsers().isEmpty, true);
    });

    test('TechNews fromJson parses correctly with tags and user info', () {
      final json = {
        'id': 1234,
        'title': 'AI Breakthrough in 2026',
        'description': 'Exploring latest advancements in LLM models.',
        'url': 'https://dev.to/article/ai-breakthrough',
        'readable_publish_date': 'Sep 27',
        'reading_time_minutes': 5,
        'tag_list': ['ai', 'machinelearning'],
        'user': {
          'name': 'Ada Lovelace',
          'profile_image_90': 'https://avatar.test/ada.png',
        },
      };

      final news = TechNews.fromJson(json);
      expect(news.id, 1234);
      expect(news.title, 'AI Breakthrough in 2026');
      expect(news.authorName, 'Ada Lovelace');
      expect(news.authorAvatar, 'https://avatar.test/ada.png');
      expect(news.tags, ['ai', 'machinelearning']);
      expect(news.readingTimeMinutes, 5);
    });

    test('GitHubRateLimit metrics and percentage calculations behave as expected', () {
      // 1. Untouched / never run: remaining == limit -> 100%
      final untouched = GitHubRateLimit(
        limit: 60,
        remaining: 60,
        used: 0,
        resetTime: DateTime.now().add(const Duration(minutes: 50)),
      );
      expect(untouched.remainingRatio, 1.0);
      expect(untouched.remainingPercentage, 100.0);
      expect(untouched.used, 0);

      // 2. Partial usage: 28 used, 32 remaining of 60
      final partial = GitHubRateLimit(
        limit: 60,
        remaining: 32,
        used: 28,
        resetTime: DateTime.now().add(const Duration(minutes: 30)),
      );
      expect(partial.used, 28);
      expect(partial.remaining, 32);
      expect(partial.remainingPercentage, closeTo(53.33, 0.1));

      // 3. Exhausted: 60 used, 0 remaining -> 0%
      final exhausted = GitHubRateLimit(
        limit: 60,
        remaining: 0,
        used: 60,
        resetTime: DateTime.now().add(const Duration(minutes: 5)),
      );
      expect(exhausted.remainingRatio, 0.0);
      expect(exhausted.remainingPercentage, 0.0);
      expect(exhausted.used, 60);

      // 4. Personal Token usage: 1001 used of 5000
      final tokenLimit = GitHubRateLimit(
        limit: 5000,
        remaining: 3999,
        used: 1001,
        resetTime: DateTime.now().add(const Duration(minutes: 45)),
      );
      expect(tokenLimit.limit, 5000);
      expect(tokenLimit.used, 1001);
      expect(tokenLimit.remaining, 3999);
      expect(tokenLimit.remainingPercentage, closeTo(79.98, 0.1));

      // 5. From JSON parsing
      final json = {
        'rate': {
          'limit': 60,
          'remaining': 45,
          'used': 15,
          'reset': 1790499958,
        }
      };
      final fromJson = GitHubRateLimit.fromJson(json);
      expect(fromJson.limit, 60);
      expect(fromJson.remaining, 45);
      expect(fromJson.used, 15);
    });

    test('CommitTitleInfo cleanTitle strips icons and emojis cleanly', () {
      const info1 = CommitTitleInfo(
        title: '🌱 Fresh Sprout',
        levelName: 'Belum Aktif',
        badgeText: 'Tier: Bronze',
        tier: 6,
        description: '',
      );
      expect(info1.cleanTitle, 'Fresh Sprout');

      const info2 = CommitTitleInfo(
        title: '🔥 Code Titan',
        levelName: 'Sangat Rajin',
        badgeText: 'Tier: Mythic',
        tier: 1,
        description: '',
      );
      expect(info2.cleanTitle, 'Code Titan');

      const info3 = CommitTitleInfo(
        title: '⚡ Relentless Committer',
        levelName: 'Sangat Rajin',
        badgeText: 'Tier: Diamond',
        tier: 2,
        description: '',
      );
      expect(info3.cleanTitle, 'Relentless Committer');
    });

    test('AppLanguage parses and maps all 6 languages accurately', () {
      expect(AppLanguage.fromCode('id'), AppLanguage.indonesian);
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('ja'), AppLanguage.japanese);
      expect(AppLanguage.fromCode('zh_Hans'), AppLanguage.chineseSimplified);
      expect(AppLanguage.fromCode('zh_CN'), AppLanguage.chineseSimplified);
      expect(AppLanguage.fromCode('zh_Hant'), AppLanguage.chineseTraditional);
      expect(AppLanguage.fromCode('zh_TW'), AppLanguage.chineseTraditional);
      expect(AppLanguage.fromCode('ko'), AppLanguage.korean);
      expect(AppLanguage.fromCode('unknown'), AppLanguage.indonesian);

      expect(AppLanguage.values.length, 6);
      for (final lang in AppLanguage.values) {
        expect(lang.code, isNotEmpty);
        expect(lang.name, isNotEmpty);
        expect(lang.nativeName, isNotEmpty);
        expect(lang.flag, isNotEmpty);
      }
    });

    test('AppLocalizations renders expected translations for all 6 languages', () {
      final idLoc = AppLocalizations(AppLanguage.indonesian);
      final enLoc = AppLocalizations(AppLanguage.english);
      final jaLoc = AppLocalizations(AppLanguage.japanese);
      final zhHansLoc = AppLocalizations(AppLanguage.chineseSimplified);
      final zhHantLoc = AppLocalizations(AppLanguage.chineseTraditional);
      final koLoc = AppLocalizations(AppLanguage.korean);

      // App Title / Repositories
      expect(idLoc.repositoriesTitle, 'Repositori');
      expect(enLoc.repositoriesTitle, 'Repositories');
      expect(jaLoc.repositoriesTitle, 'リポジトリ');
      expect(zhHansLoc.repositoriesTitle, '代码仓库');
      expect(zhHantLoc.repositoriesTitle, '代碼倉庫');
      expect(koLoc.repositoriesTitle, '리포지토리');

      // Filter labels
      expect(idLoc.filterPopular, 'Terpopuler');
      expect(enLoc.filterPopular, 'Most Popular');
      expect(jaLoc.filterPopular, '人気順');
      expect(zhHansLoc.filterPopular, '最受欢迎');
      expect(zhHantLoc.filterPopular, '最受歡迎');
      expect(koLoc.filterPopular, '인기순');

      // Commit tier clean titles
      expect(idLoc.getCommitTierCleanTitle(1), 'Code Titan');
      expect(jaLoc.getCommitTierCleanTitle(1), 'コードタイタン');
      expect(zhHansLoc.getCommitTierCleanTitle(1), '代码泰坦');
      expect(zhHantLoc.getCommitTierCleanTitle(1), '代碼泰坦');
      expect(koLoc.getCommitTierCleanTitle(1), '코드 타이탄');

      // Relative time formatting
      final tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 10));
      expect(idLoc.formatRelativeTime(tenMinutesAgo), contains('mnt lalu'));
      expect(enLoc.formatRelativeTime(tenMinutesAgo), contains('m ago'));
      expect(jaLoc.formatRelativeTime(tenMinutesAgo), contains('分前'));
      expect(zhHansLoc.formatRelativeTime(tenMinutesAgo), contains('分钟前'));
      expect(zhHantLoc.formatRelativeTime(tenMinutesAgo), contains('分鐘前'));
      expect(koLoc.formatRelativeTime(tenMinutesAgo), contains('분 전'));
    });

    test('StorageService persists and retrieves language preference correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = StorageService(prefs);

      // Default is Indonesian (id)
      expect(storage.getLanguageCode(), 'id');

      // Update to Japanese
      await storage.setLanguageCode('ja');
      expect(storage.getLanguageCode(), 'ja');

      // Update to Korean
      await storage.setLanguageCode('ko');
      expect(storage.getLanguageCode(), 'ko');
    });
  });
}
