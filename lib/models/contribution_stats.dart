class CommitTitleInfo {
  final String title;
  final String levelName;
  final String description;
  final String badgeText;
  final int tier; // 1 (Highest) to 6 (Lowest)

  const CommitTitleInfo({
    required this.title,
    required this.levelName,
    required this.description,
    required this.badgeText,
    required this.tier,
  });

  /// Nama title bersih tanpa ikon atau emoji
  String get cleanTitle {
    return title.replaceAll(RegExp(r'^[^\w\s]+\s*'), '').trim();
  }
}

class ContributionStats {
  final int thisYearContributions;
  final int lastYearContributions;
  final int currentStreak;
  final int longestStreak;
  final int totalContributions;
  final CommitTitleInfo commitTitle;
  final Map<String, int> yearlyTotals;

  const ContributionStats({
    required this.thisYearContributions,
    required this.lastYearContributions,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalContributions,
    required this.commitTitle,
    required this.yearlyTotals,
  });

  /// Evaluates commit titles based on user's streak and contribution activity:
  /// - Rajin Commit (Tier 1 & 2)
  /// - Commit Terkadang (Tier 3 & 4)
  /// - Jarang Commit / Belum Aktif (Tier 5 & 6)
  static CommitTitleInfo determineTitle({
    required int currentStreak,
    required int longestStreak,
    required int thisYearContributions,
    required int totalContributions,
  }) {
    // Tier 1: Sangat Rajin Ekstrem (Mythic/Legendary)
    if (currentStreak >= 14 || longestStreak >= 30 || thisYearContributions >= 350) {
      return const CommitTitleInfo(
        title: '🔥 Code Titan',
        levelName: 'Sangat Rajin (Master)',
        badgeText: 'Tier: Mythic',
        tier: 1,
        description: 'Komitmen baja! Tiada hari tanpa baris kode, konsistensi luar biasa.',
      );
    }
    // Tier 2: Rajin & Berkelanjutan
    else if (currentStreak >= 5 || longestStreak >= 14 || thisYearContributions >= 100) {
      return const CommitTitleInfo(
        title: '⚡ Relentless Committer',
        levelName: 'Sangat Rajin',
        badgeText: 'Tier: Diamond',
        tier: 2,
        description: 'Sangat aktif commit dan membangun proyek hampir setiap hari.',
      );
    }
    // Tier 3: Rutin & Teratur
    else if (currentStreak >= 2 || longestStreak >= 7 || thisYearContributions >= 30) {
      return const CommitTitleInfo(
        title: '🚀 Consistent Builder',
        levelName: 'Rajin & Stabil',
        badgeText: 'Tier: Platinum',
        tier: 3,
        description: 'Rutin memelihara ritme commit kode secara teratur dan stabil.',
      );
    }
    // Tier 4: Terkadang / Sewaktu-waktu (Casual)
    else if (currentStreak >= 1 || longestStreak >= 2 || thisYearContributions >= 8) {
      return const CommitTitleInfo(
        title: '☕ Weekend Warrior',
        levelName: 'Commit Terkadang',
        badgeText: 'Tier: Gold',
        tier: 4,
        description: 'Commit sewaktu-waktu di waktu senggang saat ada ide dan inspirasi.',
      );
    }
    // Tier 5: Jarang Commit (Low Activity)
    else if (thisYearContributions > 0 || totalContributions > 0) {
      return const CommitTitleInfo(
        title: '💤 Dormant Explorer',
        levelName: 'Jarang Commit',
        badgeText: 'Tier: Silver',
        tier: 5,
        description: 'Jarang mendorong commit ke publik, menikmati ritme santai.',
      );
    }
    // Tier 6: Belum Aktif / Newbie
    else {
      return const CommitTitleInfo(
        title: '🌱 Fresh Sprout',
        levelName: 'Belum Aktif',
        badgeText: 'Tier: Bronze',
        tier: 6,
        description: 'Belum ada catatan commit tahun ini. Ayo mulai nyalakan streak pertamamu!',
      );
    }
  }

  factory ContributionStats.fromContributionsApi(Map<String, dynamic> json) {
    final now = DateTime.now();
    final currentYearKey = now.year.toString();
    final lastYearKey = (now.year - 1).toString();

    final Map<String, int> yearly = {};
    if (json['total'] is Map) {
      (json['total'] as Map).forEach((k, v) {
        if (v is num) {
          yearly[k.toString()] = v.toInt();
        }
      });
    }

    final thisYear = yearly[currentYearKey] ?? 0;
    final lastYear = yearly[lastYearKey] ?? 0;
    final total = yearly.values.fold(0, (sum, count) => sum + count);

    // Parse daily contributions array
    int longest = 0;
    int current = 0;

    if (json['contributions'] is List) {
      final list = json['contributions'] as List;

      // Calculate longest streak
      int running = 0;
      for (final item in list) {
        if (item is Map) {
          final count = (item['count'] as num?)?.toInt() ?? 0;
          if (count > 0) {
            running++;
            if (running > longest) longest = running;
          } else {
            running = 0;
          }
        }
      }

      // Calculate current streak from backwards
      if (list.isNotEmpty) {
        // If today has 0, check if yesterday was active
        int startIndex = list.length - 1;
        final lastItem = list[startIndex];
        final lastCount = (lastItem is Map) ? ((lastItem['count'] as num?)?.toInt() ?? 0) : 0;

        if (lastCount == 0 && startIndex > 0) {
          // Check yesterday
          final prevItem = list[startIndex - 1];
          final prevCount = (prevItem is Map) ? ((prevItem['count'] as num?)?.toInt() ?? 0) : 0;
          if (prevCount > 0) {
            startIndex = startIndex - 1;
          }
        }

        for (int i = startIndex; i >= 0; i--) {
          final item = list[i];
          final count = (item is Map) ? ((item['count'] as num?)?.toInt() ?? 0) : 0;
          if (count > 0) {
            current++;
          } else {
            break;
          }
        }
      }
    }

    final title = determineTitle(
      currentStreak: current,
      longestStreak: longest,
      thisYearContributions: thisYear,
      totalContributions: total,
    );

    return ContributionStats(
      thisYearContributions: thisYear,
      lastYearContributions: lastYear,
      currentStreak: current,
      longestStreak: longest,
      totalContributions: total,
      commitTitle: title,
      yearlyTotals: yearly,
    );
  }

  /// Resilient fallback if third-party contributions API is unreachable:
  /// Uses public events (PushEvents) to estimate streaks and commits.
  factory ContributionStats.fromEvents(List<Map<String, dynamic>> events) {
    final now = DateTime.now();
    final currentYear = now.year;
    final lastYear = now.year - 1;

    int thisYearCount = 0;
    int lastYearCount = 0;
    final Set<String> activeDates = {};

    for (final event in events) {
      if (event['type'] == 'PushEvent') {
        final payload = event['payload'] as Map<String, dynamic>?;
        final commitCount = (payload?['commits'] as List?)?.length ??
            (payload?['size'] as num?)?.toInt() ??
            1;

        final createdAtStr = event['created_at'] as String?;
        if (createdAtStr != null) {
          final dt = DateTime.tryParse(createdAtStr)?.toLocal();
          if (dt != null) {
            if (dt.year == currentYear) {
              thisYearCount += commitCount;
            } else if (dt.year == lastYear) {
              lastYearCount += commitCount;
            }
            final dateKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
            activeDates.add(dateKey);
          }
        }
      }
    }

    // Calculate current streak from active dates
    int currentStreak = 0;
    DateTime checkDate = now;
    final todayKey = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    if (activeDates.contains(todayKey)) {
      checkDate = now;
    } else if (activeDates.contains(yesterdayKey)) {
      checkDate = yesterday;
    } else {
      checkDate = DateTime(1970);
    }

    if (checkDate.year > 1970) {
      while (true) {
        final key = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
        if (activeDates.contains(key)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    final longestStreak = currentStreak > 0 ? currentStreak : (activeDates.isNotEmpty ? 1 : 0);
    final total = thisYearCount + lastYearCount;

    final title = determineTitle(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      thisYearContributions: thisYearCount,
      totalContributions: total,
    );

    return ContributionStats(
      thisYearContributions: thisYearCount,
      lastYearContributions: lastYearCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalContributions: total,
      commitTitle: title,
      yearlyTotals: {
        currentYear.toString(): thisYearCount,
        lastYear.toString(): lastYearCount,
      },
    );
  }
}
