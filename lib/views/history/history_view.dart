import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/modules/storage/core/history_provider.dart';
import 'package:postura/shared/components/templates/history_template.dart';
import 'package:postura/shared/components/templates/common_page_shell.dart';
import 'package:postura/shared/components/ui/theme_toggle.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/shared/constants/colors.dart';
import 'package:postura/shared/constants/strings/index.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(filteredHistoryProvider);
    final settings = ref.watch(settingsProvider);

    return CommonPageShell(
      title: HistoryStrings.history,
      themeToggle: ThemeToggle(
        isDark: settings.themeMode == ThemeMode.dark,
        onToggle: () => ref.read(settingsProvider.notifier).toggleTheme(),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.destructive,
          ),
          onPressed: () =>
              _showCleanupDialog(context, ref.read(historyProvider.notifier)),
        ),
      ],
      child: HistoryTemplate(
        historyItems: history,
        onClearData: (_) {}, // No longer used directly by buttons in template
        labelNoHistory: HistoryStrings.noHistory,
        labelDuration: HistoryStrings.duration,
        labelSlouches: HistoryStrings.sloucher,
      ),
    );
  }

  void _showCleanupDialog(BuildContext context, HistoryNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(HistoryStrings.storageManagement),
        content: const Text(HistoryStrings.selectTimeframe),
        actions: [
          _dialogAction(
            context,
            HistoryStrings.all,
            () => _confirmAndClear(context, notifier, "all"),
          ),
          _dialogAction(
            context,
            HistoryStrings.oneMonth,
            () => _confirmAndClear(context, notifier, "1m"),
          ),
          _dialogAction(
            context,
            HistoryStrings.threeMonths,
            () => _confirmAndClear(context, notifier, "3m"),
          ),
          const Divider(),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(HistoryStrings.cancel),
          ),
        ],
      ),
    );
  }

  Widget _dialogAction(
    BuildContext context,
    String label,
    VoidCallback onConfirm,
  ) {
    return ListTile(title: Text(label), onTap: onConfirm);
  }

  void _confirmAndClear(
    BuildContext context,
    HistoryNotifier notifier,
    String period,
  ) {
    Navigator.pop(context); // Close selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(HistoryStrings.confirmDeletion),
        content: const Text(HistoryStrings.confirmClear),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(HistoryStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (period == "all") {
                notifier.clearAll();
              } else {
                notifier.clearOlderThan(period);
              }
              Navigator.pop(context);
            },
            child: const Text(
              HistoryStrings.clear,
              style: TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );
  }
}
