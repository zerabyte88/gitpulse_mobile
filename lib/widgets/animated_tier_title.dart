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
    final isTier1 = widget.titleInfo.tier == 1;
    // Tier 1 uses dynamic fire loop; other tiers use smooth rhythmic pulse
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: isTier1 ? 2200 : 3000),
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

        if (tier == 1) {
          return _buildTier1FireEffect(cleanTitle, progress);
        } else if (tier == 2) {
          return _buildTier2ElectricEffect(cleanTitle, progress);
        } else if (tier == 3) {
          return _buildTier3EmeraldEffect(cleanTitle, progress);
        } else {
          return _buildStandardTierBadge(tier, cleanTitle, progress);
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

  /// Tier 2 (Relentless Committer): High-energy electric plasma shimmer
  Widget _buildTier2ElectricEffect(String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.5 + 3.0 * t, -0.2),
          end: Alignment(1.5 + 3.0 * t, 0.2),
          colors: const [
            Color(0xFF0072FF),
            Color(0xFF00C6FF),
            Color(0xFF7DD3FC),
            Color(0xFF0072FF),
          ],
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
              color: const Color(0xFF00C6FF).withValues(alpha: 0.5 + 0.3 * pulse),
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
        color: const Color(0xFF061526).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF00C6FF).withValues(alpha: 0.35 + 0.25 * pulse),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0072FF).withValues(alpha: 0.15 + 0.15 * pulse),
            blurRadius: 6 + 4 * pulse,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            size: widget.fontSize * 1.05,
            color: const Color(0xFF38BDF8),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tier 3 (Consistent Builder): GitHub emerald matrix pulse
  Widget _buildTier3EmeraldEffect(String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;

    final textWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: const Color(0xFF3FB950),
        shadows: [
          Shadow(
            color: const Color(0xFF3FB950).withValues(alpha: 0.35 + 0.25 * pulse),
            blurRadius: 3 + 3 * pulse,
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
        color: const Color(0xFF061E10).withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3FB950).withValues(alpha: 0.30 + 0.20 * pulse),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EA043).withValues(alpha: 0.12 + 0.10 * pulse),
            blurRadius: 5 + 3 * pulse,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: widget.fontSize * 1.05,
            color: const Color(0xFF3FB950),
          ),
          const SizedBox(width: 4),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  /// Tiers 4, 5, 6: Minimalist ergonomic developer badge with subtle ambient breath
  Widget _buildStandardTierBadge(int tier, String title, double t) {
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;
    final ({Color accent, Color background, Color border, IconData icon}) style =
        switch (tier) {
      4 => (
          accent: const Color(0xFFD29922),
          background: const Color(0xFFD29922).withValues(alpha: 0.12),
          border: const Color(0xFFD29922).withValues(alpha: 0.35),
          icon: Icons.coffee_rounded,
        ),
      5 => (
          accent: const Color(0xFF8B949E),
          background: const Color(0xFF8B949E).withValues(alpha: 0.12),
          border: const Color(0xFF8B949E).withValues(alpha: 0.30),
          icon: Icons.bedtime_rounded,
        ),
      _ => (
          accent: const Color(0xFF56D364),
          background: const Color(0xFF56D364).withValues(alpha: 0.10),
          border: const Color(0xFF56D364).withValues(alpha: 0.28),
          icon: Icons.eco_rounded,
        ),
    };

    final textWidget = Text(
      title,
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

    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: style.accent.withValues(alpha: 0.25 + 0.15 * pulse),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            style.icon,
            size: widget.fontSize * 1.05,
            color: style.accent,
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
