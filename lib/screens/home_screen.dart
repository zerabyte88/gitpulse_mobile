import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/bookmarked_user.dart';
import '../models/tech_news.dart';
import '../services/github_api_service.dart';
import '../services/storage_service.dart';
import '../services/tech_news_service.dart';
import '../theme/app_theme.dart';
import '../widgets/settings_sheet.dart';
import '../widgets/tech_news_card.dart';
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
  final FocusNode _searchFocusNode = FocusNode();
  final TechNewsService _newsService = TechNewsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSearchFocused = false;

  // News State
  String _selectedCategory = 'ai';
  List<TechNews> _newsList = [];
  bool _isNewsLoading = true;

  List<Map<String, String>> _getCategories(AppLocalizations loc) => [
    {'id': 'ai', 'label': loc.categoryAi},
    {'id': 'technology', 'label': loc.categoryTech},
    {'id': 'opensource', 'label': loc.categoryOpenSource},
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchController.addListener(_onSearchTextChanged);
    _loadNews();
    widget.apiService.fetchRateLimit().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _onSearchTextChanged() {
    if (_isSearchFocused) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNews({bool refresh = false}) async {
    if (!refresh) {
      setState(() {
        _isNewsLoading = true;
      });
    }

    try {
      final news = await _newsService.fetchNews(tag: _selectedCategory);
      if (mounted) {
        setState(() {
          _newsList = news;
          _isNewsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isNewsLoading = false;
        });
      }
    }
  }

  void _searchUser(String username) async {
    final clean = username.trim();
    if (clean.isEmpty) return;

    _searchFocusNode.unfocus();

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
      final msg = e.toString().toLowerCase();
      final loc = AppLocalizations.of(context);
      String displayErr;
      if (msg.contains('not found') || msg.contains('404')) {
        displayErr = loc.userNotFound;
      } else if (msg.contains('rate limit') || msg.contains('403')) {
        displayErr = loc.rateLimitExceeded;
      } else {
        displayErr = loc.networkError;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = displayErr;
      });
    }
  }

  void _openSettingsSheet() {
    SettingsSheet.show(
      context,
      storageService: widget.storageService,
      apiService: widget.apiService,
      onSettingsChanged: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final bookmarkedUsers = widget.storageService.getBookmarkedUsers();
    final allRecents = widget.storageService.getRecentSearches();

    // Filter recents based on input query when user is typing
    final query = _searchController.text.trim().toLowerCase();
    final recents = query.isEmpty
        ? allRecents
        : allRecents.where((u) => u.toLowerCase().contains(query)).toList();

    final rateLimit = widget.apiService.lastRateLimit;

    return GestureDetector(
      onTap: () {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
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
                  color: Colors.black,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text('GitPulse'),
            ],
          ),
          actions: [
            if (rateLimit != null)
              GestureDetector(
                onTap: _openSettingsSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.speed_rounded,
                        size: 13,
                        color: rateLimit.remainingPercentage < 20
                            ? Colors.redAccent
                            : AppTheme.primaryCyan,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${rateLimit.used}/${rateLimit.limit}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            IconButton(
              tooltip: loc.settingsTitle,
              icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
              onPressed: _openSettingsSheet,
            ),
          ],
        ),
        body: RefreshIndicator(
          color: AppTheme.primaryCyan,
          backgroundColor: AppTheme.surfaceElevated,
          onRefresh: () async {
            await Future.wait([
              _loadNews(refresh: true),
              widget.apiService.fetchRateLimit(),
            ]);
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input with integrated dropdown
                _buildSearchBar(loc),

                // Search History Dropdown (only visible when search field is focused/clicked)
                if (_isSearchFocused) ...[
                  const SizedBox(height: 8),
                  _buildSearchHistoryPanel(loc, recents, allRecents),
                ],

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
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.redAccent,
                          size: 18,
                        ),
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

                // Bookmarks Section (Profil Favorit Tersimpan dengan Foto Profil)
                _buildBookmarksSection(loc, bookmarkedUsers),

                const SizedBox(height: 28),

                // Latest Tech & AI News Section
                _buildTechNewsSection(loc),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations loc) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
      onSubmitted: _searchUser,
      decoration: InputDecoration(
        hintText: loc.searchHint,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: _isSearchFocused ? AppTheme.primaryCyan : AppTheme.textSecondary,
        ),
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
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty || _isSearchFocused)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textMuted),
                      tooltip: loc.close,
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                        setState(() {});
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryCyan),
                    tooltip: 'GitHub',
                    onPressed: () => _searchUser(_searchController.text),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchHistoryPanel(
    AppLocalizations loc,
    List<String> filteredRecents,
    List<String> allRecents,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 8, top: 10, bottom: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  size: 17,
                  color: AppTheme.primaryCyan,
                ),
                const SizedBox(width: 8),
                Text(
                  loc.recentSearches,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (allRecents.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await widget.storageService.clearHistory();
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      loc.clearAll,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: AppTheme.textMuted),
                  tooltip: loc.close,
                  onPressed: () => _searchFocusNode.unfocus(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Quick action if typed query does not exactly match
          if (_searchController.text.trim().isNotEmpty) ...[
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.search_rounded, size: 18, color: AppTheme.primaryCyan),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                  children: [
                    TextSpan(
                      text: '"${_searchController.text.trim()}"',
                      style: const TextStyle(
                        color: AppTheme.primaryCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' ➔ GitHub'),
                  ],
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.primaryCyan),
              onTap: () => _searchUser(_searchController.text),
            ),
            const Divider(height: 1, color: AppTheme.border),
          ],

          // History items list
          if (filteredRecents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppTheme.textMuted.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.noRecentSearches,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredRecents.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: AppTheme.border),
              itemBuilder: (context, index) {
                final username = filteredRecents[index];
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.only(left: 14, right: 6),
                  leading: const Icon(
                    Icons.history_rounded,
                    size: 17,
                    color: AppTheme.textMuted,
                  ),
                  title: Text(
                    username,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.north_west_rounded, size: 15, color: AppTheme.textMuted),
                        tooltip: username,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          _searchController.text = username;
                          _searchController.selection = TextSelection.fromPosition(
                            TextPosition(offset: username.length),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.textMuted),
                        tooltip: loc.close,
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          await widget.storageService.removeRecentSearch(username);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _searchController.text = username;
                    _searchUser(username);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBookmarksSection(AppLocalizations loc, List<BookmarkedUser> bookmarks) {
    if (bookmarks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentAmber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.star_outline_rounded,
                color: AppTheme.accentAmber,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.favoriteProfiles,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    loc.emptyBookmarks,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.bookmark_rounded,
              size: 19,
              color: AppTheme.accentAmber,
            ),
            const SizedBox(width: 8),
            Text(
              loc.favoriteProfiles,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentAmber.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${bookmarks.length}',
                style: const TextStyle(
                  color: AppTheme.accentAmber,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: bookmarks.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final user = bookmarks[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _searchController.text = user.username;
                  _searchUser(user.username);
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      // Avatar Photo with Amber Border
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.accentAmber.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            user.avatarUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppTheme.surface,
                                child: const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: AppTheme.accentAmber,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppTheme.surface,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 22,
                                color: AppTheme.accentAmber,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // User Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'GitHub ➔',
                              style: TextStyle(
                                color: AppTheme.primaryCyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Remove favorite button
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: AppTheme.textMuted,
                        ),
                        visualDensity: VisualDensity.compact,
                        tooltip: loc.removeFavorite,
                        onPressed: () async {
                          await widget.storageService.removeBookmark(user.username);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTechNewsSection(AppLocalizations loc) {
    final categories = _getCategories(loc);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: AppTheme.primaryCyan,
                ),
                const SizedBox(width: 8),
                Text(
                  loc.techNewsTitle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20, color: AppTheme.textSecondary),
              tooltip: loc.refresh,
              onPressed: () => _loadNews(refresh: true),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Category Filter Chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat['id'] == _selectedCategory;
              return ChoiceChip(
                label: Text(
                  cat['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12.5,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primaryCyan,
                backgroundColor: AppTheme.surfaceElevated,
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryCyan : AppTheme.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                showCheckmark: false,
                onSelected: (selected) {
                  if (selected && _selectedCategory != cat['id']) {
                    setState(() {
                      _selectedCategory = cat['id']!;
                    });
                    _loadNews();
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // News Content
        if (_isNewsLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Column(
                children: [
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.loadingNews,
                    style: TextStyle(
                      color: AppTheme.textMuted.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_newsList.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                loc.noNewsFound,
                style: TextStyle(
                  color: AppTheme.textMuted.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _newsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return TechNewsCard(news: _newsList[index]);
            },
          ),
      ],
    );
  }
}

