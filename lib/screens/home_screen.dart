import 'package:flutter/material.dart';
import '../services/github_api_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'stats_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  final GitHubApiService apiService;

  const HomeScreen({
    super.key,
    required this.storageService,
    required this.apiService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchUser(String username) async {
    final clean = username.trim();
    if (clean.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await widget.apiService.fetchUserStats(clean);
      await widget.storageService.addRecentSearch(clean);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatsDetailScreen(
            stats: stats,
            storageService: widget.storageService,
          ),
        ),
      ).then((_) => setState(() {}));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _showTokenDialog() {
    final tokenController = TextEditingController(
      text: widget.storageService.getToken() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.key_rounded, color: AppTheme.primaryCyan, size: 20),
            SizedBox(width: 8),
            Text('GitHub Token (Opsional)'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menambahkan Personal Access Token meningkatkan kuota GitHub API dari 60 menjadi 5.000 request per jam.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(
                hintText: 'ghp_xxxxxxxxxxxx',
                labelText: 'Personal Access Token',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              final token = tokenController.text.trim();
              await widget.storageService.setToken(token);
              widget.apiService.personalAccessToken = token.isEmpty ? null : token;
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan token berhasil diperbarui!'),
                    backgroundColor: AppTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = widget.storageService.getBookmarks();
    final recents = widget.storageService.getRecentSearches();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryCyan, AppTheme.primaryViolet],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.insights_rounded,
                color: Color(0xFF0B0F19),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text('GitPulse'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Pengaturan Token',
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
            onPressed: _showTokenDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Intro Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryCyan.withValues(alpha: 0.12),
                    AppTheme.primaryViolet.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Coding Stats & Rhythm ⚡',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pantau performa profil, jam produktif ngoding, dan koleksi bintang GitHub dalam satu aplikasi.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _searchUser,
              decoration: InputDecoration(
                hintText: 'Ketik username GitHub (misal: torvalds)',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryCyan),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryCyan,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded,
                            color: AppTheme.primaryCyan),
                        onPressed: () => _searchUser(_searchController.text),
                      ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Quick Samples Chips
            const Text(
              'Jelajahi Profil Populer',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'torvalds',
                'flutter',
                'google',
                'antigravity',
              ].map((user) {
                return ActionChip(
                  label: Text('@$user'),
                  labelStyle: const TextStyle(
                    color: AppTheme.primaryCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: AppTheme.surface,
                  side: const BorderSide(color: AppTheme.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    _searchController.text = user;
                    _searchUser(user);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Bookmarks Section
            if (bookmarks.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.bookmark_rounded,
                      size: 18, color: AppTheme.accentAmber),
                  SizedBox(width: 8),
                  Text(
                    'Profil Favorit Tersimpan',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookmarks.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final username = bookmarks[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _searchController.text = username;
                        _searchUser(username);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_circle_rounded,
                              size: 18,
                              color: AppTheme.accentAmber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              username,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Recent Searches Section
            if (recents.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.history_rounded,
                          size: 18, color: AppTheme.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'Riwayat Pencarian',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget.storageService.clearHistory();
                      setState(() {});
                    },
                    child: const Text(
                      'Hapus Semua',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...recents.map((username) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  dense: true,
                  leading: const Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                  title: Text(
                    username,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.north_west_rounded,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  onTap: () {
                    _searchController.text = username;
                    _searchUser(username);
                  },
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
