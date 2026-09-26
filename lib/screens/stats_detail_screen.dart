import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_stats.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_chart.dart';
import '../widgets/language_chart.dart';
import '../widgets/repo_tile.dart';
import '../widgets/stat_card.dart';

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

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.storageService.isBookmarked(widget.stats.user.login);
  }

  void _toggleBookmark() async {
    await widget.storageService.toggleBookmark(widget.stats.user.login);
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
    final topLang = widget.stats.languageCounts.entries.isNotEmpty
        ? (widget.stats.languageCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key
        : 'N/A';

    final text = '''
⚡ GitPulse Profile Snapshot
👤 @${u.login} (${u.name ?? 'Developer'})
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

  @override
  Widget build(BuildContext context) {
    final user = widget.stats.user;

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
            const SizedBox(height: 16),

            // Key Metrics Grid
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
            const SizedBox(height: 20),

            // Language Chart
            LanguageChart(languageCounts: widget.stats.languageCounts),
            const SizedBox(height: 20),

            // Activity Chart
            ActivityChart(hourlyActivity: widget.stats.hourlyActivity),
            const SizedBox(height: 24),

            // Top Repositories Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        size: 20, color: AppTheme.accentAmber),
                    SizedBox(width: 8),
                    Text(
                      'Repositori Terpopuler',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${widget.stats.repos.length} total',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (widget.stats.repos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Tidak ada repositori publik.',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                ),
              )
            else
              ...widget.stats.repos
                  .take(10)
                  .map((repo) => RepoTile(repo: repo)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
