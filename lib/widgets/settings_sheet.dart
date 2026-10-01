import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_language.dart';
import '../localization/app_localizations.dart';
import '../models/github_rate_limit.dart';
import '../services/app_language_service.dart';
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

  Future<void> _saveToken(AppLocalizations loc) async {
    final token = _tokenController.text.trim();
    await widget.storageService.setToken(token.isEmpty ? null : token);
    widget.apiService.personalAccessToken = token.isEmpty ? null : token;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            token.isEmpty ? loc.tokenDeletedToast : loc.tokenSavedToast,
          ),
          backgroundColor: token.isEmpty ? AppTheme.surfaceElevated : AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    widget.onSettingsChanged?.call();
    await _refreshRateLimit();
  }

  Future<void> _clearToken(AppLocalizations loc) async {
    _tokenController.clear();
    await widget.storageService.setToken(null);
    widget.apiService.personalAccessToken = null;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.tokenDeletedToast),
          backgroundColor: AppTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    widget.onSettingsChanged?.call();
    await _refreshRateLimit();
  }

  Widget _buildAboutInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
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
      progressColor = AppTheme.accentRed;
    }

    final currentLang = AppLanguageService.currentLanguage;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1.2),
          left: BorderSide(color: AppTheme.border, width: 1),
          right: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Sheet Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border, width: 0.8),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppTheme.primaryCyan,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.settingsTitle,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          loc.settingsSubtitle,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // CARD 1: Language Selection
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.translate_rounded,
                          color: AppTheme.primaryCyan,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc.languageSectionTitle,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppTheme.border, width: 0.8),
                          ),
                          child: Text(
                            '${currentLang.flag} ${currentLang.nativeName}',
                            style: const TextStyle(
                              color: AppTheme.primaryCyan,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.languageSectionSubtitle,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grid of 6 Languages
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 8) / 2;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppLanguage.values.map((lang) {
                            final isSelected = lang == currentLang;
                            return SizedBox(
                              width: itemWidth,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  if (lang == currentLang) return;
                                  final messenger = ScaffoldMessenger.of(context);
                                  final toastText = '${loc.languageChangedToast}: ${lang.nativeName} (${lang.name})';
                                  await AppLanguageService.changeLanguage(
                                    lang,
                                    widget.storageService,
                                  );
                                  widget.onSettingsChanged?.call();
                                  if (!mounted) return;
                                  setState(() {});
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(toastText),
                                      backgroundColor: AppTheme.surfaceElevated,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primaryCyan.withValues(alpha: 0.10)
                                        : AppTheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primaryCyan
                                          : AppTheme.border,
                                      width: isSelected ? 1.2 : 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        lang.flag,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              lang.nativeName,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? AppTheme.primaryCyan
                                                    : AppTheme.textPrimary,
                                                fontSize: 12,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              lang.name,
                                              style: const TextStyle(
                                                color: AppTheme.textMuted,
                                                fontSize: 9.5,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 15,
                                          color: AppTheme.primaryCyan,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 2: GitHub API Rate Limit Tracker
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          color: AppTheme.primaryCyan,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc.rateLimitStatus,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_isLoadingRateLimit)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: AppTheme.primaryCyan,
                            ),
                          )
                        else
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: _refreshRateLimit,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 13,
                                    color: AppTheme.primaryCyan,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loc.refresh,
                                    style: const TextStyle(
                                      color: AppTheme.primaryCyan,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Mode Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hasToken
                            ? AppTheme.accentGreen.withValues(alpha: 0.10)
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: hasToken
                              ? AppTheme.accentGreen.withValues(alpha: 0.25)
                              : AppTheme.border,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasToken ? Icons.verified_rounded : Icons.info_outline_rounded,
                            size: 13,
                            color: hasToken ? AppTheme.accentGreen : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            hasToken
                                ? loc.personalTokenActive
                                : loc.standardMode,
                            style: TextStyle(
                              color: hasToken ? AppTheme.accentGreen : AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Metrics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.requestsUsed,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$usedCount',
                                    style: TextStyle(
                                      color: progressColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $totalLimit',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
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
                            Text(
                              loc.remainingQuota,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${remainingPercent.toStringAsFixed(remainingPercent % 1 == 0 ? 0 : 1)}%',
                              style: TextStyle(
                                color: progressColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: rateLimit.remainingRatio,
                        minHeight: 6,
                        backgroundColor: AppTheme.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${loc.resetIn} ${rateLimit.resetCountdown} (${DateFormat('HH:mm').format(rateLimit.resetTime)})',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 3: GitHub Personal Access Token
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_rounded,
                          color: AppTheme.accentAmber,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc.githubTokenTitle,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppTheme.border, width: 0.8),
                          ),
                          child: Text(
                            loc.optionalBadge,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      loc.tokenDescription,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _tokenController,
                      obscureText: _obscureToken,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: loc.tokenHint,
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          size: 16,
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
                                size: 16,
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
                                  size: 15,
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
                    const SizedBox(height: 8),

                    InkWell(
                      borderRadius: BorderRadius.circular(6),
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
                              size: 15,
                              color: AppTheme.primaryCyan,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              loc.howToCreateToken,
                              style: const TextStyle(
                                color: AppTheme.primaryCyan,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showTokenGuide) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border, width: 0.8),
                        ),
                        child: Text(
                          loc.tokenGuideContent,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        if (hasToken)
                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline_rounded, size: 15),
                            label: Text(loc.deleteToken),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.accentRed,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () => _clearToken(loc),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => _saveToken(loc),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            foregroundColor: const Color(0xFF0D1117),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            loc.saveToken,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 4: About GitPulse & Build Version Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.primaryCyan,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc.aboutApp,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppTheme.accentGreen.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: const Text(
                            AppConfig.appVersion,
                            style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.appDescriptionLabel,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppTheme.border),
                    const SizedBox(height: 10),
                    _buildAboutInfoRow(loc.appVersionLabel, AppConfig.appVersion),
                    const SizedBox(height: 6),
                    _buildAboutInfoRow(loc.buildNumberLabel, '${AppConfig.buildNumber} (Release APK)'),
                    const SizedBox(height: 6),
                    _buildAboutInfoRow('Architecture', 'Clean Layered (Flutter 3)'),
                    const SizedBox(height: 6),
                    _buildAboutInfoRow('License', AppConfig.license),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.open_in_new_rounded, size: 13),
                        label: Text(
                          loc.viewOnGitHub,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryCyan,
                          side: const BorderSide(color: AppTheme.border, width: 0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(AppConfig.githubRepoUrl);
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                      ),
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
