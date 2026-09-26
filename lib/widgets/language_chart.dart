import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageChart extends StatelessWidget {
  final Map<String, int> languageCounts;

  const LanguageChart({super.key, required this.languageCounts});

  static const List<Color> _palette = [
    Color(0xFF00E5FF), // Cyan
    Color(0xFF8B5CF6), // Violet
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF3B82F6), // Blue
    Color(0xFF64748B), // Slate
  ];

  @override
  Widget build(BuildContext context) {
    if (languageCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Center(
          child: Text(
            'Tidak ada data bahasa pemrograman publik.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
        ),
      );
    }

    // Sort by count descending
    final sortedEntries = languageCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Limit to top 5 + "Lainnya"
    final topEntries = sortedEntries.take(5).toList();
    final otherCount = sortedEntries
        .skip(5)
        .fold<int>(0, (sum, item) => sum + item.value);

    final totalCount = languageCounts.values.fold<int>(0, (a, b) => a + b);

    final List<PieChartSectionData> sections = [];
    final List<Map<String, dynamic>> legendItems = [];

    for (var i = 0; i < topEntries.length; i++) {
      final entry = topEntries[i];
      final color = _palette[i % _palette.length];
      final percent = (entry.value / totalCount) * 100;

      sections.add(
        PieChartSectionData(
          color: color,
          value: entry.value.toDouble(),
          title: '${percent.toStringAsFixed(0)}%',
          radius: 38,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B0F19),
          ),
        ),
      );

      legendItems.add({
        'name': entry.key,
        'percent': percent,
        'count': entry.value,
        'color': color,
      });
    }

    if (otherCount > 0) {
      final percent = (otherCount / totalCount) * 100;
      final color = _palette.last;
      sections.add(
        PieChartSectionData(
          color: color,
          value: otherCount.toDouble(),
          title: '${percent.toStringAsFixed(0)}%',
          radius: 38,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B0F19),
          ),
        ),
      );
      legendItems.add({
        'name': 'Lainnya',
        'percent': percent,
        'count': otherCount,
        'color': color,
      });
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, size: 18, color: AppTheme.primaryCyan),
              SizedBox(width: 8),
              Text(
                'Distribusi Bahasa Pemrograman',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: legendItems.map((item) {
              final color = item['color'] as Color;
              final name = item['name'] as String;
              final percent = item['percent'] as double;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${percent.toStringAsFixed(1)}%)',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
