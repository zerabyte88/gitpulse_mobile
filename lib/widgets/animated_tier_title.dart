import 'package:flutter/material.dart';
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({List<Color> gradient, Color glow}) _getTierPalette(int tier) {
    switch (tier) {
      case 1:
        // Mythic / Master - Fiery Lava & Blazing Sun
        return (
          gradient: const [
            Color(0xFFFF3D00),
            Color(0xFFFF9100),
            Color(0xFFFFEA00),
          ],
          glow: const Color(0xFFFF5722),
        );
      case 2:
        // Diamond - Electric Neon Cyan & Royal Blue
        return (
          gradient: const [
            Color(0xFF00E5FF),
            Color(0xFF38BDF8),
            Color(0xFF3B82F6),
          ],
          glow: const Color(0xFF00E5FF),
        );
      case 3:
        // Platinum - Radiant Emerald & Teal
        return (
          gradient: const [
            Color(0xFF10B981),
            Color(0xFF14B8A6),
            Color(0xFF06B6D4),
          ],
          glow: const Color(0xFF10B981),
        );
      case 4:
        // Gold - Warm Amber & Sunset Gold
        return (
          gradient: const [
            Color(0xFFF59E0B),
            Color(0xFFFBBF24),
            Color(0xFFFB923C),
          ],
          glow: const Color(0xFFF59E0B),
        );
      case 5:
        // Silver - Sleek Chrome & Steel
        return (
          gradient: const [
            Color(0xFF94A3B8),
            Color(0xFFE2E8F0),
            Color(0xFF64748B),
          ],
          glow: const Color(0xFF94A3B8),
        );
      default:
        // Bronze / Fresh Sprout - Living Mint & Fresh Sage
        return (
          gradient: const [
            Color(0xFF10B981),
            Color(0xFF34D399),
            Color(0xFFA3E635),
          ],
          glow: const Color(0xFF10B981),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _getTierPalette(widget.titleInfo.tier);
    final cleanTitle = widget.titleInfo.cleanTitle;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final glowAlpha = 0.25 + 0.35 * progress;
        final borderAlpha = 0.35 + 0.35 * progress;

        Widget textWidget = ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.5 + 3.0 * progress, -0.5),
              end: Alignment(1.5 + 3.0 * progress, 0.5),
              colors: [
                palette.gradient[0],
                palette.gradient[1],
                palette.gradient[2 % palette.gradient.length],
                palette.gradient[0],
              ],
            ).createShader(bounds);
          },
          child: Text(
            cleanTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              shadows: [
                Shadow(
                  color: palette.glow.withValues(alpha: glowAlpha),
                  blurRadius: 4 + 4 * progress,
                ),
              ],
            ),
          ),
        );

        if (!widget.showBadgeContainer) {
          return textWidget;
        }

        return Container(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: palette.glow.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: palette.glow.withValues(alpha: borderAlpha),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.glow.withValues(alpha: 0.15 * progress),
                blurRadius: 6 + 4 * progress,
                spreadRadius: 0,
              ),
            ],
          ),
          child: textWidget,
        );
      },
    );
  }
}
