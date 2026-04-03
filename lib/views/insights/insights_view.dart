import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/modules/posture/core/posture_provider.dart';
import 'package:postura/shared/components/templates/insights_template.dart';
import 'package:postura/shared/components/templates/common_page_shell.dart';
import 'package:postura/shared/components/ui/theme_toggle.dart';
import 'package:postura/modules/storage/core/history_provider.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/shared/constants/app_constants.dart';
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
        onComparePressed: () => _showComparisonModal(context, ref),
        labelTrend: InsightsStrings.realTimeTrend,
        labelSlouches: InsightsStrings.slouches,
        labelScore: InsightsStrings.score,
        labelCompare: InsightsStrings.compareYesterday,
      ),
    );
  }

  void _showComparisonModal(BuildContext context, WidgetRef ref) {
    final filterDate = ref.read(historyDateFilterProvider);
    final today = filterDate ?? DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayStats = ref.read(sessionStatsProvider(today));
    final yesterdayStats = ref.read(sessionStatsProvider(yesterday));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spaceLG),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              InsightsStrings.compareYesterday,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.spaceLG),
            Row(
              children: [
                Expanded(
                  child: _buildStatsColumn(
                    context,
                    InsightsStrings.todaySummary,
                    todayStats,
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: _buildStatsColumn(
                    context,
                    InsightsStrings.yesterdaySummary,
                    yesterdayStats,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceLG),
            _buildTrendRow(context, todayStats, yesterdayStats),
            const SizedBox(height: AppConstants.spaceLG),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(InsightsStrings.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsColumn(
    BuildContext context,
    String title,
    SessionStats stats,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppConstants.spaceMD),
        _statItem(
          context,
          InsightsStrings.totalSessions,
          stats.totalSessions.toString(),
        ),
        _statItem(context, InsightsStrings.avgScore, "${stats.averageScore}%"),
        _statItem(
          context,
          InsightsStrings.totalDuration,
          _formatDuration(stats.totalDuration),
        ),
      ],
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendRow(
    BuildContext context,
    SessionStats today,
    SessionStats yesterday,
  ) {
    if (yesterday.totalSessions == 0) return const SizedBox.shrink();

    final scoreDiff = today.averageScore - yesterday.averageScore;
    final isBetter = scoreDiff >= 0;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: (isBetter ? Colors.green : Colors.amber).withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBetter ? Icons.trending_up : Icons.trending_down,
              color: isBetter ? Colors.green : Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "${scoreDiff.abs()}% ${isBetter ? InsightsStrings.betterThanYesterday : InsightsStrings.worseThanYesterday}",
              style: TextStyle(
                color: isBetter ? Colors.green : Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return "${h}h ${m}m";
    return "${m}m";
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
