import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/github_rate_limit.dart';
import '../services/github_api_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsSheet extends StatefulWidget {
  final StorageService storageService;
  final GitHubApiService apiService;
  final VoidCallback? onSettingsChanged;

  const SettingsSheet({
    super.key,
    required this.storageService,
    required this.apiService,
    this.onSettingsChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required StorageService storageService,
    required GitHubApiService apiService,
    VoidCallback? onSettingsChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsSheet(
        storageService: storageService,
        apiService: apiService,
        onSettingsChanged: onSettingsChanged,
      ),
    );
  }

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late final TextEditingController _tokenController;
  bool _obscureToken = true;
  bool _isLoadingRateLimit = false;
  bool _showTokenGuide = false;
  GitHubRateLimit? _rateLimit;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(
      text: widget.storageService.getToken() ?? '',
    );
    _rateLimit = widget.apiService.lastRateLimit;
    _refreshRateLimit();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _refreshRateLimit() async {
    setState(() {
      _isLoadingRateLimit = true;
    });

    final rateLimit = await widget.apiService.fetchRateLimit();

    if (mounted) {
      setState(() {
        _rateLimit = rateLimit;
        _isLoadingRateLimit = false;
      });
    }
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    await widget.storageService.setToken(token.isEmpty ? null : token);
    widget.apiService.personalAccessToken = token.isEmpty ? null : token;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            token.isEmpty
                ? 'Token dihapus. Kembali ke kuota standar 60 req/jam.'
                : 'Token disimpan! Kuota berhasil ditingkatkan ke 5.000 req/jam.',
          ),
          backgroundColor: token.isEmpty ? AppTheme.surfaceElevated : AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    widget.onSettingsChanged?.call();
    await _refreshRateLimit();
  }

  Future<void> _clearToken() async {
    _tokenController.clear();
    await widget.storageService.setToken(null);
    widget.apiService.personalAccessToken = null;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token GitHub berhasil dihapus.'),
          backgroundColor: AppTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    widget.onSettingsChanged?.call();
    await _refreshRateLimit();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final hasToken = widget.storageService.getToken() != null &&
        widget.storageService.getToken()!.trim().isNotEmpty;
    final rateLimit = _rateLimit ??
        GitHubRateLimit.defaultLimit(hasToken: hasToken);

    final remainingPercent = rateLimit.remainingPercentage;
    final usedCount = rateLimit.used;
    final totalLimit = rateLimit.limit;

    Color progressColor;
    if (remainingPercent > 40) {
      progressColor = AppTheme.accentGreen;
    } else if (remainingPercent > 15) {
      progressColor = AppTheme.accentAmber;
    } else {
      progressColor = Colors.redAccent;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1.5),
          left: BorderSide(color: AppTheme.border, width: 1),
          right: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sheet Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppTheme.primaryCyan,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengaturan & Kuota API',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pantau penggunaan kuota & kelola token',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // CARD 1: GitHub API Rate Limit Tracker
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rate limit title & refresh button
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          color: AppTheme.primaryCyan,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Status Kuota API GitHub',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_isLoadingRateLimit)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryCyan,
                            ),
                          )
                        else
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _refreshRateLimit,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 14,
                                    color: AppTheme.primaryCyan,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Refresh',
                                    style: TextStyle(
                                      color: AppTheme.primaryCyan,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Mode Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: hasToken
                            ? AppTheme.accentGreen.withValues(alpha: 0.12)
                            : AppTheme.primaryCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasToken
                              ? AppTheme.accentGreen.withValues(alpha: 0.3)
                              : AppTheme.primaryCyan.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasToken ? Icons.verified_rounded : Icons.info_outline_rounded,
                            size: 14,
                            color: hasToken ? AppTheme.accentGreen : AppTheme.primaryCyan,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hasToken
                                ? 'Personal Token Aktif (Maks 5.000 req/jam)'
                                : 'Mode Standar (Maks 60 req/jam)',
                            style: TextStyle(
                              color: hasToken ? AppTheme.accentGreen : AppTheme.primaryCyan,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics: Requests Used and Remaining Percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Request Digunakan',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$usedCount',
                                    style: TextStyle(
                                      color: progressColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $totalLimit',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Sisa Kuota',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${remainingPercent.toStringAsFixed(remainingPercent % 1 == 0 ? 0 : 1)}%',
                              style: TextStyle(
                                color: progressColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Progress Bar: 100% when unused, 0% when exhausted
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: rateLimit.remainingRatio,
                        minHeight: 8,
                        backgroundColor: AppTheme.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reset Timer Info
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Reset dalam ${rateLimit.resetCountdown} (${DateFormat('HH:mm').format(rateLimit.resetTime)} WIB)',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // CARD 2: GitHub Personal Access Token
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with neat "Opsional" badge
                    Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_rounded,
                          color: AppTheme.accentAmber,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'GitHub Personal Token',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.border,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Opsional',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Tambahkan token GitHub untuk menaikkan kuota dari 60 menjadi 5.000 request per jam.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Token input field
                    TextField(
                      controller: _tokenController,
                      obscureText: _obscureToken,
                      style: const TextStyle(fontSize: 13.5),
                      decoration: InputDecoration(
                        hintText: 'ghp_xxxxxxxxxxxx atau github_pat_...',
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          size: 18,
                          color: AppTheme.textMuted,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _obscureToken
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 18,
                                color: AppTheme.textMuted,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureToken = !_obscureToken;
                                });
                              },
                            ),
                            if (_tokenController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  size: 16,
                                  color: AppTheme.textMuted,
                                ),
                                onPressed: () {
                                  _tokenController.clear();
                                  setState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),

                    // Guide accordion / expander
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _showTokenGuide = !_showTokenGuide;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              _showTokenGuide
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: AppTheme.primaryCyan,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Cara membuat GitHub Token',
                              style: TextStyle(
                                color: AppTheme.primaryCyan,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showTokenGuide) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. Buka github.com ➔ Profil ➔ Settings.\n'
                              '2. Gulir ke bawah ke Developer Settings.\n'
                              '3. Pilih Personal Access Tokens (Classic).\n'
                              '4. Generate new token (tanpa perlu centang izin khusus).\n'
                              '5. Salin token lalu tempelkan di atas.',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11.5,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        if (hasToken)
                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline_rounded, size: 16),
                            label: const Text('Hapus Token'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: _clearToken,
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _saveToken,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Simpan Token',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
