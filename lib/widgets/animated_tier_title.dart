import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/contribution_stats.dart';

class AnimatedTierTitle extends StatefulWidget {
  final CommitTitleInfo titleInfo;
  final double fontSize;
  final bool showBadgeContainer;
  final EdgeInsetsGeometry? padding;

  const AnimatedTierTitle({
    super.key,
    required this.titleInfo,
    this.fontSize = 11.5,
    this.showBadgeContainer = true,
    this.padding,
  });

  @override
  State<AnimatedTierTitle> createState() => _AnimatedTierTitleState();
}

class _AnimatedTierTitleState extends State<AnimatedTierTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Subtle ambient breath animation for premium status badges
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({Color accent, Color background, Color border}) _getTierStyle(int tier) {
    switch (tier) {
      case 1:
        // Tier 1: Master / Code Titan - Refined Amber / Gold
        return (
          accent: const Color(0xFFF59E0B),
          background: const Color(0xFFF59E0B).withValues(alpha: 0.12),
          border: const Color(0xFFF59E0B).withValues(alpha: 0.35),
        );
      case 2:
        // Tier 2: Relentless Committer - GitHub Electric Blue
        return (
          accent: const Color(0xFF58A6FF),
          background: const Color(0xFF58A6FF).withValues(alpha: 0.12),
          border: const Color(0xFF58A6FF).withValues(alpha: 0.35),
        );
      case 3:
        // Tier 3: Consistent Builder - GitHub Emerald
        return (
          accent: const Color(0xFF3FB950),
          background: const Color(0xFF3FB950).withValues(alpha: 0.12),
          border: const Color(0xFF3FB950).withValues(alpha: 0.35),
        );
      case 4:
        // Tier 4: Weekend Warrior - Warm Bronze
        return (
          accent: const Color(0xFFD29922),
          background: const Color(0xFFD29922).withValues(alpha: 0.12),
          border: const Color(0xFFD29922).withValues(alpha: 0.35),
        );
      case 5:
        // Tier 5: Dormant Explorer - Steel Slate
        return (
          accent: const Color(0xFF8B949E),
          background: const Color(0xFF8B949E).withValues(alpha: 0.12),
          border: const Color(0xFF8B949E).withValues(alpha: 0.30),
        );
      default:
        // Tier 6: Fresh Sprout - Muted Mint / Sage
        return (
          accent: const Color(0xFF56D364),
          background: const Color(0xFF56D364).withValues(alpha: 0.10),
          border: const Color(0xFF56D364).withValues(alpha: 0.28),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getTierStyle(widget.titleInfo.tier);
    final cleanTitle = AppLocalizations.of(context)
        .getCommitTierCleanTitle(widget.titleInfo.tier);

    final textWidget = Text(
      cleanTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: style.accent,
      ),
    );

    if (!widget.showBadgeContainer) {
      return textWidget;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Subtle ambient opacity shimmer (ergonomic, non-distracting)
        final animValue = _controller.value;
        final borderAlpha = 0.25 + 0.15 * animValue;

        return Container(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: style.accent.withValues(alpha: borderAlpha),
              width: 1,
            ),
          ),
          child: textWidget,
        );
      },
    );
  }
}
