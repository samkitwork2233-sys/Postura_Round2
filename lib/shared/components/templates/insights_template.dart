import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../ui/glass_card.dart';

class InsightsTemplate extends StatelessWidget {
  final Widget graphWidget;
  final String slouchCount;
  final String postureScore;
  final String comparisonText;
  final bool isBetter;
  final String labelTrend;
  final String labelSlouches;
  final String labelScore;

  const InsightsTemplate({
    required this.graphWidget,
    required this.slouchCount,
    required this.postureScore,
    required this.comparisonText,
    required this.isBetter,
    required this.labelTrend,
    required this.labelSlouches,
    required this.labelScore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spaceMD),
          Text(labelTrend, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            height: 200,
            width: double.infinity,
            child: graphWidget,
          ),
          const SizedBox(height: AppConstants.spaceLG),
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  child: Column(
                    children: [
                      Text(labelSlouches, style: theme.textTheme.bodySmall),
                      Text(slouchCount, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Expanded(
                child: GlassCard(
                  child: Column(
                    children: [
                      Text(labelScore, style: theme.textTheme.bodySmall),
                      Text("$postureScore%", style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isBetter ? theme.colorScheme.primary : Colors.amber,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceLG),
          GlassCard(
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  isBetter ? Icons.trending_up : Icons.trending_down,
                  color: isBetter ? theme.colorScheme.primary : Colors.amber,
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Expanded(
                  child: Text(
                    comparisonText,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceXL),
        ],
      ),
    );
  }
}
