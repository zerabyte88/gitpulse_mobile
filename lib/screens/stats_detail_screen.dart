import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contribution_stats.dart';
import '../models/github_repo.dart';
import '../models/user_stats.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_chart.dart';
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
    await widget.storageService.toggleBookmark(
      widget.stats.user.login,
      avatarUrl: widget.stats.user.avatarUrl,
    );
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? 'Profil ${widget.stats.user.login} disimpan ke favorit!'
                : 'Dihapus dari favorit.',
          ),
          backgroundColor: AppTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareSummary() {
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
🎖️ Title: ${cStats.commitTitle.title} (${cStats.commitTitle.levelName})
🔥 Streak: ${cStats.currentStreak} hari (Rekor: ${cStats.longestStreak} hari)
📅 Kontribusi Tahun Ini: ${cStats.thisYearContributions}
🎭 Persona: ${widget.stats.developerPersona}
⭐ Total Stars: ${widget.stats.totalStars}
📦 Repos: ${u.publicRepos} | 👥 Followers: ${u.followers}
💻 Top Language: $topLang
🔗 https://github.com/${u.login}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ringkasan statistik berhasil disalin ke clipboard!'),
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

  String _getFilterLabel(RepoSortFilter filter) {
    switch (filter) {
      case RepoSortFilter.popular:
        return 'Terpopuler';
      case RepoSortFilter.newest:
        return 'Terbaru';
      case RepoSortFilter.oldest:
        return 'Terlama';
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

  Widget _buildQuickFilterChip(RepoSortFilter filter, String label, IconData icon) {
    final isSelected = _currentFilter == filter;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryCyan.withValues(alpha: 0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryCyan
                : AppTheme.border,
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? AppTheme.primaryCyan : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryCyan : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitHabitBanner(ContributionStats cStats) {
    final titleInfo = cStats.commitTitle;

    Color primaryBadgeColor;
    Color secondaryBadgeColor;
    IconData habitIcon;

    switch (titleInfo.tier) {
      case 1:
        primaryBadgeColor = const Color(0xFFFF5722); // Orange Red
        secondaryBadgeColor = AppTheme.accentAmber;
        habitIcon = Icons.local_fire_department_rounded;
        break;
      case 2:
        primaryBadgeColor = AppTheme.primaryCyan;
        secondaryBadgeColor = const Color(0xFF3B82F6); // Blue
        habitIcon = Icons.bolt_rounded;
        break;
      case 3:
        primaryBadgeColor = AppTheme.accentGreen;
        secondaryBadgeColor = const Color(0xFF14B8A6); // Teal
        habitIcon = Icons.trending_up_rounded;
        break;
      case 4:
        primaryBadgeColor = AppTheme.primaryViolet;
        secondaryBadgeColor = const Color(0xFFEC4899); // Pink
        habitIcon = Icons.coffee_rounded;
        break;
      case 5:
        primaryBadgeColor = const Color(0xFF64748B); // Slate
        secondaryBadgeColor = const Color(0xFF475569);
        habitIcon = Icons.bedtime_rounded;
        break;
      default:
        primaryBadgeColor = const Color(0xFF10B981); // Mint
        secondaryBadgeColor = const Color(0xFF334155);
        habitIcon = Icons.eco_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryBadgeColor.withValues(alpha: 0.18),
            secondaryBadgeColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryBadgeColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBadgeColor.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  habitIcon,
                  color: primaryBadgeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            titleInfo.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: primaryBadgeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: primaryBadgeColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            titleInfo.levelName,
                            style: TextStyle(
                              color: primaryBadgeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      titleInfo.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                      color: primaryBadgeColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Current: ${cStats.currentStreak} hari',
                      style: TextStyle(
                        color: primaryBadgeColor,
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
                      'Max Streak: ${cStats.longestStreak} hari',
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
    final user = widget.stats.user;
    final cStats = widget.stats.contributionStats;
    final currentYear = DateTime.now().year;
    final lastYear = currentYear - 1;
    final repos = _filteredAndSortedRepos;
    final displayedRepos = _showAllRepos ? repos : repos.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.login}'),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? 'Hapus Bookmark' : 'Simpan Profil',
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppTheme.accentAmber : AppTheme.textSecondary,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            tooltip: 'Salin Ringkasan',
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
                            Text(
                              user.name ?? user.login,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
            _buildCommitHabitBanner(cStats),
            const SizedBox(height: 14),

            // Developer Persona Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryViolet.withValues(alpha: 0.2),
                    AppTheme.primaryCyan.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryViolet.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryViolet.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppTheme.primaryCyan,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stats.developerPersona,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.stats.personaDescription,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section: GitHub Contributions & Streak Statistics
            const Row(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: Color(0xFFFF5722),
                ),
                SizedBox(width: 8),
                Text(
                  'Statistik Kontribusi & Streak',
                  style: TextStyle(
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
                    label: 'Streak Saat Ini',
                    value: '${cStats.currentStreak} Hari',
                    icon: Icons.whatshot_rounded,
                    accentColor: const Color(0xFFFF5722),
                    subtitle: cStats.currentStreak > 0
                        ? 'Sedang aktif 🔥'
                        : 'Belum aktif',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Streak Terpanjang',
                    value: '${cStats.longestStreak} Hari',
                    icon: Icons.emoji_events_rounded,
                    accentColor: AppTheme.accentAmber,
                    subtitle: 'Rekor konsistensi',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Kontribusi $currentYear',
                    value: '${cStats.thisYearContributions}',
                    icon: Icons.calendar_today_rounded,
                    accentColor: AppTheme.primaryCyan,
                    subtitle: 'Tahun ini',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Kontribusi $lastYear',
                    value: '${cStats.lastYearContributions}',
                    icon: Icons.history_toggle_off_rounded,
                    accentColor: AppTheme.primaryViolet,
                    subtitle: 'Tahun lalu',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Key Metrics Grid
            const Row(
              children: [
                Icon(
                  Icons.analytics_rounded,
                  size: 18,
                  color: AppTheme.primaryCyan,
                ),
                SizedBox(width: 8),
                Text(
                  'Ikhtisar Akun',
                  style: TextStyle(
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
                    label: 'Total Stars',
                    value: '${widget.stats.totalStars}',
                    icon: Icons.star_rounded,
                    accentColor: AppTheme.accentAmber,
                    subtitle: 'di semua repo',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Public Repos',
                    value: '${user.publicRepos}',
                    icon: Icons.folder_copy_rounded,
                    accentColor: AppTheme.primaryCyan,
                    subtitle: 'terdaftar',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Followers',
                    value: '${user.followers}',
                    icon: Icons.people_rounded,
                    accentColor: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Total Forks',
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
                    const Text(
                      'Repositori',
                      style: TextStyle(
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
                        '${widget.stats.repos.length} total',
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
                  tooltip: 'Filter Repositori',
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
                          _getFilterLabel(_currentFilter),
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
                      'Terpopuler',
                      'Bintang & Fork terbanyak',
                      Icons.star_rounded,
                      AppTheme.accentAmber,
                    ),
                    _buildPopupMenuItem(
                      RepoSortFilter.newest,
                      'Terbaru',
                      'Commit & update paling baru',
                      Icons.update_rounded,
                      AppTheme.primaryCyan,
                    ),
                    _buildPopupMenuItem(
                      RepoSortFilter.oldest,
                      'Terlama',
                      'Aktivitas commit terlama',
                      Icons.history_rounded,
                      AppTheme.primaryViolet,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quick Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildQuickFilterChip(
                    RepoSortFilter.popular,
                    'Terpopuler',
                    Icons.star_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickFilterChip(
                    RepoSortFilter.newest,
                    'Terbaru',
                    Icons.update_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickFilterChip(
                    RepoSortFilter.oldest,
                    'Terlama',
                    Icons.history_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (repos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Tidak ada repositori publik.',
                    style: TextStyle(color: AppTheme.textMuted),
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
                          ? 'Tampilkan Lebih Sedikit'
                          : 'Tampilkan Semua (${repos.length} Repositori)',
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
