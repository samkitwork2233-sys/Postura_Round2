import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/modules/storage/core/history_provider.dart';
import 'package:postura/modules/posture/core/posture_provider.dart';
import 'package:postura/shared/components/templates/settings_template.dart';
import 'package:postura/shared/components/templates/common_page_shell.dart';
import 'package:postura/shared/components/ui/theme_toggle.dart';
import 'package:postura/shared/constants/strings/index.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final postureNotifier = ref.read(postureProvider.notifier);
    final selectedDate = ref.watch(historyDateFilterProvider);
    final dateFilterNotifier = ref.read(historyDateFilterProvider.notifier);

    return CommonPageShell(
      title: SettingsStrings.settings,
      themeToggle: ThemeToggle(
        isDark: settings.themeMode == ThemeMode.dark,
        onToggle: () => settingsNotifier.toggleTheme(),
      ),
      child: SettingsTemplate(
        threshold: settings.threshold,
        onThresholdChanged: (val) {
          settingsNotifier.setThreshold(val);
          postureNotifier.setThreshold(val);
        },
        vibrationDuration: settings.vibrationDuration,
        onVibrationChanged: (val) {
          settingsNotifier.setVibrationDuration(val);
        },
        minAngle: settings.minAngle,
        maxAngle: settings.maxAngle,
        onMinAngleChanged: (val) {
          settingsNotifier.setMinAngle(val);
        },
        onMaxAngleChanged: (val) {
          settingsNotifier.setMaxAngle(val);
        },
        soundEnabled: settings.soundEnabled,
        onSoundToggled: (val) {
          settingsNotifier.setSoundEnabled(val);
        },
        selectedDate: selectedDate,
        onSelectDate: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            dateFilterNotifier.state = picked;
          }
        },
        onClearDate: () => dateFilterNotifier.state = null,
        labelThreshold: SettingsStrings.threshold,
        labelSensitivity: SettingsStrings.sensitivity,
        descThreshold: SettingsStrings.thresholdDescription,
        labelAlertFeedback: SettingsStrings.alertFeedback,
        labelSoundAlerts: SettingsStrings.sound,
        labelVibrationMs: SettingsStrings.vibrationMs,
        labelDateFilter: SettingsStrings.dateFilter,
        labelSelectDate: SettingsStrings.selectDate,
        labelClearFilter: SettingsStrings.clearFilter,
      ),
    );
  }
}
