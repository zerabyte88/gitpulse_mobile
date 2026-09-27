import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../localization/app_localizations.dart';
import '../models/contribution_stats.dart';
import '../models/github_repo.dart';
import '../models/user_stats.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_chart.dart';
import '../widgets/animated_tier_title.dart';
import '../widgets/language_chart.dart';
import '../widgets/repo_tile.dart';
import '../widgets/stat_card.dart';

enum RepoSortFilter {
  popular,
  newest,
  oldest,
}

class StatsDetailScreen extends StatefulWidget {
  final UserStats stats;
  final StorageService storageService;

  const StatsDetailScreen({
    super.key,
    required this.stats,
    required this.storageService,
  });

  @override
  State<StatsDetailScreen> createState() => _StatsDetailScreenState();
}

class _StatsDetailScreenState extends State<StatsDetailScreen> {
  late bool _isBookmarked;
  RepoSortFilter _currentFilter = RepoSortFilter.popular;
  bool _showAllRepos = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.storageService.isBookmarked(widget.stats.user.login);
  }

  void _toggleBookmark() async {
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final username = widget.stats.user.login;
    await widget.storageService.toggleBookmark(
      username,
      avatarUrl: widget.stats.user.avatarUrl,
    );
    if (!mounted) return;
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? loc.profileSavedToFavorites(username)
              : loc.profileRemovedFromFavorites,
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareSummary() {
    final loc = AppLocalizations.of(context);
    final u = widget.stats.user;
    final cStats = widget.stats.contributionStats;
    final topLang = widget.stats.languageCounts.entries.isNotEmpty
        ? (widget.stats.languageCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key
        : 'N/A';

    final text = '''
⚡ GitPulse Profile Snapshot
👤 @${u.login} (${u.name ?? 'Developer'})
🎖️ Title: ${cStats.commitTitle.title} (${loc.getCommitTierLevelName(cStats.commitTitle.tier)})
🔥 Streak: ${cStats.currentStreak} ${loc.daysUnit} (Max: ${cStats.longestStreak} ${loc.daysUnit})
📅 ${loc.thisYearContributions}: ${cStats.thisYearContributions}
🎭 Persona: ${widget.stats.developerPersona}
⭐ ${loc.totalStars}: ${widget.stats.totalStars}
📦 ${loc.repositoriesTitle}: ${u.publicRepos} | 👥 ${loc.followers}: ${u.followers}
💻 ${loc.topLanguagesTitle}: $topLang
🔗 https://github.com/${u.login}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.summaryCopiedToast),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<GitHubRepo> get _filteredAndSortedRepos {
    final list = List<GitHubRepo>.from(widget.stats.repos);
    switch (_currentFilter) {
      case RepoSortFilter.popular:
        list.sort((a, b) {
          final starsCmp = b.stargazersCount.compareTo(a.stargazersCount);
          if (starsCmp != 0) return starsCmp;
          return b.forksCount.compareTo(a.forksCount);
        });
        break;
      case RepoSortFilter.newest:
        list.sort((a, b) {
          final dateA = a.latestActivityDate ?? DateTime(1970);
          final dateB = b.latestActivityDate ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });
        break;
      case RepoSortFilter.oldest:
        list.sort((a, b) {
          final dateA = a.latestActivityDate ?? DateTime(1970);
          final dateB = b.latestActivityDate ?? DateTime(1970);
          return dateA.compareTo(dateB);
        });
        break;
    }
    return list;
  }

  String _getFilterLabel(RepoSortFilter filter, AppLocalizations loc) {
    switch (filter) {
      case RepoSortFilter.popular:
        return loc.filterPopular;
      case RepoSortFilter.newest:
        return loc.filterNewest;
      case RepoSortFilter.oldest:
        return loc.filterOldest;
    }
  }

  PopupMenuItem<RepoSortFilter> _buildPopupMenuItem(
    RepoSortFilter filter,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = _currentFilter == filter;
    return PopupMenuItem<RepoSortFilter>(
      value: filter,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryCyan : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 6),
            const Icon(Icons.check_rounded, size: 16, color: AppTheme.primaryCyan),
          ],
        ],
      ),
    );
  }


  ({Color primary, Color secondary, IconData icon}) _getCommitHabitStyle(int tier) {
    switch (tier) {
      case 1:
        return (
          primary: const Color(0xFFFF5722),
          secondary: AppTheme.accentAmber,
          icon: Icons.local_fire_department_rounded,
        );
      case 2:
        return (
          primary: AppTheme.primaryCyan,
          secondary: const Color(0xFF3B82F6),
          icon: Icons.bolt_rounded,
        );
      case 3:
        return (
          primary: AppTheme.accentGreen,
          secondary: const Color(0xFF14B8A6),
          icon: Icons.trending_up_rounded,
        );
      case 4:
        return (
          primary: AppTheme.primaryViolet,
          secondary: const Color(0xFFEC4899),
          icon: Icons.coffee_rounded,
        );
      case 5:
        return (
          primary: const Color(0xFF64748B),
          secondary: const Color(0xFF475569),
          icon: Icons.bedtime_rounded,
        );
      default:
        return (
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF334155),
          icon: Icons.eco_rounded,
        );
    }
  }

  Widget _buildCommitHabitBanner(ContributionStats cStats, AppLocalizations loc) {
    final titleInfo = cStats.commitTitle;
    final habitStyle = _getCommitHabitStyle(titleInfo.tier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            habitStyle.primary.withValues(alpha: 0.18),
            habitStyle.secondary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: habitStyle.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: AnimatedTierTitle(
                  titleInfo: titleInfo,
                  fontSize: 15.5,
                  showBadgeContainer: false,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: habitStyle.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: habitStyle.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  loc.getCommitTierLevelName(titleInfo.tier),
                  style: TextStyle(
                    color: habitStyle.primary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.background.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.whatshot_rounded,
                      size: 13,
                      color: habitStyle.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Current: ${cStats.currentStreak} ${loc.daysUnit}',
                      style: TextStyle(
                        color: habitStyle.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      size: 13,
                      color: AppTheme.accentAmber,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Max Streak: ${cStats.longestStreak} ${loc.daysUnit}',
                      style: const TextStyle(
                        color: AppTheme.accentAmber,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  titleInfo.badgeText,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final user = widget.stats.user;
    final cStats = widget.stats.contributionStats;
    final titleInfo = cStats.commitTitle;
    final currentYear = DateTime.now().year;
    final lastYear = currentYear - 1;
    final repos = _filteredAndSortedRepos;
    final displayedRepos = _showAllRepos ? repos : repos.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.login}'),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? loc.removeFavorite : loc.saveFavorite,
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppTheme.accentAmber : AppTheme.textSecondary,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            tooltip: loc.shareProfile,
            icon: const Icon(Icons.share_rounded, color: AppTheme.primaryCyan),
            onPressed: _shareSummary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.surface, AppTheme.surfaceElevated],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppTheme.primaryCyan.withValues(alpha: 0.2),
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name ?? user.login,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedTierTitle(
                                  titleInfo: titleInfo,
                                  fontSize: 11.5,
                                  showBadgeContainer: true,
                                ),
                              ],
                            ),
                            Text(
                              '@${user.login}',
                              style: const TextStyle(
                                color: AppTheme.primaryCyan,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (user.location != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 13,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      user.location!,
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.bio!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Commit Habit Title Banner (Tingkat & Gelar Aktivitas Commit)
            _buildCommitHabitBanner(cStats, loc),
            const SizedBox(height: 20),

            // Section: GitHub Contributions & Streak Statistics
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: Color(0xFFFF5722),
                ),
                const SizedBox(width: 8),
                Text(
                  loc.streakStatsTitle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: loc.currentStreak,
                    value: '${cStats.currentStreak} ${loc.daysUnit}',
                    icon: Icons.whatshot_rounded,
                    accentColor: const Color(0xFFFF5722),
                    subtitle: cStats.currentStreak > 0
                        ? loc.activeNowBadge
                        : loc.notActiveYetBadge,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: loc.longestStreak,
                    value: '${cStats.longestStreak} ${loc.daysUnit}',
                    icon: Icons.emoji_events_rounded,
                    accentColor: AppTheme.accentAmber,
                    subtitle: loc.consistencyRecord,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: '${loc.thisYearContributions} ($currentYear)',
                    value: '${cStats.thisYearContributions}',
                    icon: Icons.calendar_today_rounded,
                    accentColor: AppTheme.primaryCyan,
                    subtitle: loc.thisYearSubtitle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: '${loc.totalContributions} ($lastYear)',
                    value: '${cStats.lastYearContributions}',
                    icon: Icons.history_toggle_off_rounded,
                    accentColor: AppTheme.primaryViolet,
                    subtitle: loc.lastYearSubtitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Key Metrics Grid
            Row(
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  size: 18,
                  color: AppTheme.primaryCyan,
                ),
                const SizedBox(width: 8),
                Text(
                  loc.accountOverviewTitle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: loc.totalStars,
                    value: '${widget.stats.totalStars}',
                    icon: Icons.star_rounded,
                    accentColor: AppTheme.accentAmber,
                    subtitle: loc.acrossAllRepos,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: loc.publicRepos,
                    value: '${user.publicRepos}',
                    icon: Icons.folder_copy_rounded,
                    accentColor: AppTheme.primaryCyan,
                    subtitle: loc.registeredReposSubtitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: loc.followers,
                    value: '${user.followers}',
                    icon: Icons.people_rounded,
                    accentColor: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: loc.totalForks,
                    value: '${widget.stats.totalForks}',
                    icon: Icons.call_split_rounded,
                    accentColor: AppTheme.primaryViolet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Language Chart
            LanguageChart(languageCounts: widget.stats.languageCounts),
            const SizedBox(height: 20),

            // Activity Chart
            ActivityChart(hourlyActivity: widget.stats.hourlyActivity),
            const SizedBox(height: 24),

            // Repositories Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.folder_special_rounded,
                      size: 20,
                      color: AppTheme.primaryCyan,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.repositoriesTitle,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tempat baru Total Repositori
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Text(
                        '${widget.stats.repos.length} ${loc.totalCountBadge}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // Tombol Filter di sebelah kanan
                PopupMenuButton<RepoSortFilter>(
                  initialValue: _currentFilter,
                  tooltip: loc.filterRepositories,
                  onSelected: (filter) {
                    setState(() {
                      _currentFilter = filter;
                    });
                  },
                  color: AppTheme.surfaceElevated,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppTheme.border),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sort_rounded,
                          size: 14,
                          color: AppTheme.primaryCyan,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getFilterLabel(_currentFilter, loc),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                      RepoSortFilter.popular,
                      loc.filterPopular,
                      loc.filterPopularDesc,
                      Icons.star_rounded,
                      AppTheme.accentAmber,
                    ),
                    _buildPopupMenuItem(
                      RepoSortFilter.newest,
                      loc.filterNewest,
                      loc.filterNewestDesc,
                      Icons.update_rounded,
                      AppTheme.primaryCyan,
                    ),
                    _buildPopupMenuItem(
                      RepoSortFilter.oldest,
                      loc.filterOldest,
                      loc.filterOldestDesc,
                      Icons.history_rounded,
                      AppTheme.primaryViolet,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (repos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    loc.noPublicRepos,
                    style: const TextStyle(color: AppTheme.textMuted),
                  ),
                ),
              )
            else ...[
              ...displayedRepos.map((repo) => RepoTile(repo: repo)),
              if (repos.length > 10) ...[
                const SizedBox(height: 6),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllRepos = !_showAllRepos;
                      });
                    },
                    icon: Icon(
                      _showAllRepos
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primaryCyan,
                    ),
                    label: Text(
                      _showAllRepos
                          ? loc.showFewerRepos
                          : loc.showAllReposCount(repos.length),
                      style: const TextStyle(
                        color: AppTheme.primaryCyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
