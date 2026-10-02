import 'dart:math' as math;
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
    final tier = widget.titleInfo.tier;
    final durationMs = switch (tier) {
      1 => 2200,
      2 => 1800, // fast energetic electric crackle
      3 => 2400, // digital matrix rhythm
      4 => 2600, // golden sunlight sweep
      5 => 3200, // calm cosmic drift
      _ => 3000, // gentle organic breath
    };
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tier = widget.titleInfo.tier;
    final cleanTitle = AppLocalizations.of(context)
        .getCommitTierCleanTitle(tier);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        switch (tier) {
          case 1:
            return _buildTier1FireEffect(cleanTitle, progress);
          case 2:
            return _buildTier2ElectricEffect(cleanTitle, progress);
          case 3:
            return _buildTier3EmeraldEffect(cleanTitle, progress);
          case 4:
            return _buildTier4SolarAmberEffect(cleanTitle, progress);
          case 5:
            return _buildTier5CosmicSilverEffect(cleanTitle, progress);
          default:
            return _buildTier6SpringSproutEffect(cleanTitle, progress);
        }
      },
    );
  }

  /// Tier 1 (Code Titan): Authentic animated fire & flame embers effect
  Widget _buildTier1FireEffect(String title, double t) {
    // Natural flame flicker physics (harmonic superposition)
    final flicker = (math.sin(t * 2 * math.pi) * 0.65 +
        math.sin(t * 6 * math.pi + 1.2) * 0.35);
    final wave = math.sin(t * 2 * math.pi) * 0.25;

    // Fiery blazing text with dynamic vertical heatwave gradient
    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(wave, 1.2),
          end: Alignment(-wave, -1.0),
          colors: const [
            Color(0xFFFF1744), // Base deep ruby ember
            Color(0xFFFF3D00), // Blazing flame red
            Color(0xFFFF9100), // Hot flame orange
            Color(0xFFFFD600), // Core flame gold
            Color(0xFFFFF9C4), // White-hot incandescent tip
          ],
          stops: const [0.0, 0.25, 0.55, 0.82, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          shadows: [
            Shadow(
              color: const Color(0xFFFF9100)
                  .withValues(alpha: 0.85 + 0.15 * flicker.abs()),
              blurRadius: 3.5 + 2.5 * flicker.abs(),
              offset: const Offset(0, -1),
            ),
            Shadow(
              color: const Color(0xFFFF3D00)
                  .withValues(alpha: 0.65 + 0.20 * flicker.abs()),
              blurRadius: 8.0 + 4.0 * flicker.abs(),
              offset: const Offset(0, -2),
            ),
            Shadow(
              color: const Color(0xFFFF1744).withValues(alpha: 0.35),
              blurRadius: 14.0,
            ),
          ],
        ),
      ),
    );

    // Overlay lightweight floating embers that drift upwards
    final flameWidget = CustomPaint(
      painter: _FlameEmbersPainter(progress: t),
      child: textWidget,
    );

    if (!widget.showBadgeContainer) {
      return flameWidget;
    }

    final borderHeat = Color.lerp(
      const Color(0xFFFF3D00),
      const Color(0xFFFF9100),
      (flicker + 1) / 2,
    )!;

    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2B0B04).withValues(alpha: 0.88),
            const Color(0xFF1A0602).withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: borderHeat.withValues(alpha: 0.55 + 0.25 * flicker.abs()),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00)
                .withValues(alpha: 0.25 + 0.15 * flicker.abs()),
            blurRadius: 8 + 6 * flicker.abs(),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: widget.fontSize * 1.05,
            color: borderHeat,
          ),
          const SizedBox(width: 4),
          Flexible(child: flameWidget),
        ],
      ),
    );
  }

  /// Tier 2 (Relentless Committer - Diamond): Electric Lightning Plasma Arc Shimmer
  Widget _buildTier2ElectricEffect(String title, double t) {
    // High-frequency electric spark micro-jitter
    final crackle = math.sin(t * 8 * math.pi) * 0.25 + math.sin(t * 14 * math.pi) * 0.15;
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.8 + 3.6 * t, -0.4),
          end: Alignment(1.8 + 3.6 * t, 0.4),
          colors: const [
            Color(0xFF0072FF), // Deep cosmic blue
            Color(0xFF00D2FF), // Electric cyan
            Color(0xFF7000FF), // Neon plasma violet
            Color(0xFFE0F2FE), // White-hot electric core
            Color(0xFF00D2FF), // Electric cyan
            Color(0xFF0072FF), // Deep cosmic blue
          ],
          stops: const [0.0, 0.25, 0.50, 0.70, 0.85, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          shadows: [
            Shadow(
              color: const Color(0xFF00D2FF).withValues(alpha: 0.75 + crackle.abs()),
              blurRadius: 5 + 4 * pulse,
              offset: const Offset(0, -0.5),
            ),
            Shadow(
              color: const Color(0xFF7000FF).withValues(alpha: 0.55 + 0.2 * pulse),
              blurRadius: 10 + 6 * pulse,
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
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF031024).withValues(alpha: 0.90),
            const Color(0xFF08061E).withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF00D2FF).withValues(alpha: 0.45 + 0.35 * pulse),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0072FF).withValues(alpha: 0.30 + 0.25 * pulse),
            blurRadius: 8 + 6 * pulse,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            size: widget.fontSize * 1.1,
            color: Color.lerp(
              const Color(0xFF00D2FF),
              const Color(0xFFE0F2FE),
              pulse,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tier 3 (Consistent Builder - Platinum): Emerald Cyber Matrix Pulse
  Widget _buildTier3EmeraldEffect(String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.6 + 3.2 * t, 0.0),
          end: Alignment(1.6 + 3.2 * t, 0.0),
          colors: const [
            Color(0xFF059669), // Deep emerald
            Color(0xFF10B981), // Matrix green
            Color(0xFF6EE7B7), // Light cyber mint
            Color(0xFF00FF87), // Vivid neon emerald
            Color(0xFF059669), // Deep emerald
          ],
          stops: const [0.0, 0.30, 0.55, 0.80, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          shadows: [
            Shadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.55 + 0.35 * pulse),
              blurRadius: 4 + 5 * pulse,
            ),
            Shadow(
              color: const Color(0xFF00FF87).withValues(alpha: 0.30 + 0.20 * pulse),
              blurRadius: 9 + 4 * pulse,
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
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFF04190F).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.40 + 0.30 * pulse),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.20 + 0.20 * pulse),
            blurRadius: 6 + 5 * pulse,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.code_rounded,
            size: widget.fontSize * 1.05,
            color: const Color(0xFF00FF87),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tier 4 (Weekend Warrior - Gold): Solar Amber Sunburst Gleam
  Widget _buildTier4SolarAmberEffect(String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.8 + 3.6 * t, -0.3),
          end: Alignment(1.8 + 3.6 * t, 0.3),
          colors: const [
            Color(0xFFD97706), // Deep solar amber
            Color(0xFFF59E0B), // Radiant gold
            Color(0xFFFEF3C7), // White solar flare
            Color(0xFFFBBF24), // Bright gold
            Color(0xFFD97706), // Deep solar amber
          ],
          stops: const [0.0, 0.35, 0.60, 0.80, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          shadows: [
            Shadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.50 + 0.30 * pulse),
              blurRadius: 4 + 4 * pulse,
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
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFF201604).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.35 + 0.25 * pulse),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withValues(alpha: 0.18 + 0.16 * pulse),
            blurRadius: 6 + 4 * pulse,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny_rounded,
            size: widget.fontSize * 1.05,
            color: const Color(0xFFFBBF24),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tier 5 (Dormant Explorer - Silver): Cosmic Starlight Nebula Drift
  Widget _buildTier5CosmicSilverEffect(String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.5 + 3.0 * t, 0.0),
          end: Alignment(1.5 + 3.0 * t, 0.0),
          colors: const [
            Color(0xFF94A3B8), // Slate silver
            Color(0xFFCBD5E1), // Cool moonlit silver
            Color(0xFFE2E8F0), // Pure starlight
            Color(0xFFC4B5FD), // Soft nebula lavender
            Color(0xFF94A3B8), // Slate silver
          ],
          stops: const [0.0, 0.30, 0.55, 0.80, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          shadows: [
            Shadow(
              color: const Color(0xFFC4B5FD).withValues(alpha: 0.30 + 0.20 * pulse),
              blurRadius: 3 + 3 * pulse,
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
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFF10141D).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF94A3B8).withValues(alpha: 0.25 + 0.20 * pulse),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4B5FD).withValues(alpha: 0.10 + 0.10 * pulse),
            blurRadius: 5 + 3 * pulse,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore_outlined,
            size: widget.fontSize * 1.05,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tier 6 (Fresh Sprout - Bronze): Spring Dewdrop Bloom Pulse
  Widget _buildTier6SpringSproutEffect(String title, double t) {
    // Gentle natural breath rhythm
    final breath = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: Color.lerp(
          const Color(0xFF4ADE80),
          const Color(0xFF86EFAC),
          breath,
        ),
        shadows: [
          Shadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.25 + 0.25 * breath),
            blurRadius: 3 + 3 * breath,
          ),
        ],
      ),
    );

    if (!widget.showBadgeContainer) {
      return textWidget;
    }

    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFF09170E).withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: 0.25 + 0.20 * breath),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco_rounded,
            size: widget.fontSize * 1.05,
            color: Color.lerp(
              const Color(0xFF4ADE80),
              const Color(0xFF86EFAC),
              breath,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

}

/// Lightweight hardware-accelerated canvas painter rendering floating fire embers
class _FlameEmbersPainter extends CustomPainter {
  final double progress;

  _FlameEmbersPainter({required this.progress});

  static const List<_EmberSpec> _embers = [
    _EmberSpec(xRatio: 0.10, speed: 1.0, size: 1.6, phase: 0.05, color: Color(0xFFFF9100)),
    _EmberSpec(xRatio: 0.26, speed: 1.3, size: 1.3, phase: 0.40, color: Color(0xFFFFD600)),
    _EmberSpec(xRatio: 0.48, speed: 0.9, size: 2.0, phase: 0.75, color: Color(0xFFFF3D00)),
    _EmberSpec(xRatio: 0.65, speed: 1.4, size: 1.4, phase: 0.20, color: Color(0xFFFF9100)),
    _EmberSpec(xRatio: 0.82, speed: 1.1, size: 1.8, phase: 0.60, color: Color(0xFFFFEA00)),
    _EmberSpec(xRatio: 0.95, speed: 0.95, size: 1.2, phase: 0.90, color: Color(0xFFFF5722)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    for (final ember in _embers) {
      final t = (progress * ember.speed + ember.phase) % 1.0;
      // Drift upwards from slightly below text to above text
      final y = size.height * 1.05 - t * (size.height * 1.35);

      // Natural draft air sway
      final sway = math.sin((t * 2 + ember.phase) * math.pi) * 3.5;
      final x = (size.width * ember.xRatio + sway).clamp(0.0, size.width);

      // Opacity bell curve
      final alpha = math.sin(t * math.pi).clamp(0.0, 1.0);
      if (alpha <= 0.02) continue;

      // Outer glowing halo
      final glowPaint = Paint()
        ..color = ember.color.withValues(alpha: alpha * 0.75)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, ember.size * 0.7);
      canvas.drawCircle(Offset(x, y), ember.size, glowPaint);

      // Inner incandescent core
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.90);
      canvas.drawCircle(Offset(x, y), ember.size * 0.45, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FlameEmbersPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _EmberSpec {
  final double xRatio;
  final double speed;
  final double size;
  final double phase;
  final Color color;

  const _EmberSpec({
    required this.xRatio,
    required this.speed,
    required this.size,
    required this.phase,
    required this.color,
  });
}
