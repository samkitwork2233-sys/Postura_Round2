import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../ui/glass_card.dart';

class HistoryTemplate extends StatelessWidget {
  final List<dynamic> historyItems;
  final Function(String) onClearData;
  final String labelNoHistory;
  final String labelDuration;
  final String labelSlouches;

  const HistoryTemplate({
    required this.historyItems,
    required this.onClearData,
    required this.labelNoHistory,
    required this.labelDuration,
    required this.labelSlouches,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // History List
        Expanded(
          child: historyItems.isEmpty
              ? Center(
                  child: Text(labelNoHistory, style: theme.textTheme.bodyMedium),
                )
              : ListView.separated(
                  itemCount: historyItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spaceMD),
                  itemBuilder: (_, index) {
                    final item = historyItems[index];
                    return GlassCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(Icons.history, color: theme.colorScheme.primary),
                        ),
                        title: Text(item.date),
                        subtitle: Text("$labelDuration: ${item.duration}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${item.score}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("${item.slouches} $labelSlouches", style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

