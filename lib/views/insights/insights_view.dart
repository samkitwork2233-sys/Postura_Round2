import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/posture/core/posture_provider.dart';
import 'package:postura/shared/components/templates/insights_template.dart';
import 'package:postura/shared/components/templates/common_page_shell.dart';
import 'package:postura/shared/components/ui/theme_toggle.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/shared/constants/strings/index.dart';

import 'package:fl_chart/fl_chart.dart';

class InsightsView extends ConsumerWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postureState = ref.watch(postureProvider);
    final settings = ref.watch(settingsProvider);
    final diff = postureState.comparisonScore != null
        ? postureState.score - postureState.comparisonScore!
        : null;

    String comparisonText = "No previous data for comparison.";
    bool isBetter = true;
    if (diff != null) {
      isBetter = diff >= 0;
      comparisonText =
          "${diff.abs()}% ${isBetter ? InsightsStrings.betterThanYesterday : InsightsStrings.worseThanYesterday}";
    }

    return CommonPageShell(
      title: InsightsStrings.insights,
      themeToggle: ThemeToggle(
        isDark: settings.themeMode == ThemeMode.dark,
        onToggle: () => ref.read(settingsProvider.notifier).toggleTheme(),
      ),
      child: InsightsTemplate(
        graphWidget: _buildRealGraph(
          postureState.deviationHistory,
          Theme.of(context),
        ),
        slouchCount: postureState.slouchCount.toString(),
        postureScore: postureState.score.toString(),
        comparisonText: comparisonText,
        isBetter: isBetter,
        labelTrend: InsightsStrings.realTimeTrend,
        labelSlouches: InsightsStrings.slouches,
        labelScore: InsightsStrings.score,
      ),
    );
  }

  Widget _buildRealGraph(List<double> history, ThemeData theme) {
    if (history.isEmpty) {
      return const Center(child: Text("No real-time data"));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 45,
        lineBarsData: [
          LineChartBarData(
            spots: history
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
