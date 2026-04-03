import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../ui/glass_card.dart';


class SettingsTemplate extends StatelessWidget {
  final double threshold;
  final ValueChanged<double> onThresholdChanged;
  final double vibrationDuration;
  final ValueChanged<double> onVibrationChanged;
  final bool soundEnabled;
  final ValueChanged<bool> onSoundToggled;
  final DateTime? selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback onClearDate;
  final String labelThreshold;
  final String labelSensitivity;
  final String descThreshold;
  final String labelAlertFeedback;
  final String labelSoundAlerts;
  final String labelVibrationMs;
  final String labelDateFilter;
  final String labelSelectDate;
  final String labelClearFilter;

  const SettingsTemplate({
    required this.threshold,
    required this.onThresholdChanged,
    required this.vibrationDuration,
    required this.onVibrationChanged,
    required this.soundEnabled,
    required this.onSoundToggled,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onClearDate,
    required this.labelThreshold,
    required this.labelSensitivity,
    required this.descThreshold,
    required this.labelAlertFeedback,
    required this.labelSoundAlerts,
    required this.labelVibrationMs,
    required this.labelDateFilter,
    required this.labelSelectDate,
    required this.labelClearFilter,
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
          // Threshold Section
          Text(labelThreshold, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text(labelSensitivity)),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        controller: TextEditingController(text: threshold.toInt().toString()),
                        onSubmitted: (val) => onThresholdChanged(double.tryParse(val) ?? threshold),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: threshold.clamp(5.0, 30.0),
                  min: 5,
                  max: 30,
                  activeColor: theme.colorScheme.primary,
                  onChanged: onThresholdChanged,
                ),
                Text(
                  descThreshold,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),

          const SizedBox(height: AppConstants.spaceLG),
          // Date Filter Section
          Text(labelDateFilter, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate == null 
                            ? labelClearFilter 
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (selectedDate != null)
                        Text(
                          labelDateFilter,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: onClearDate,
                  ),
                ElevatedButton.icon(
                  onPressed: onSelectDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(labelSelectDate),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),

          // Alerts Section
          Text(labelAlertFeedback, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(labelSoundAlerts),
                  value: soundEnabled,
                  onChanged: onSoundToggled,
                  activeThumbColor: theme.colorScheme.primary,
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Text(labelVibrationMs)),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: vibrationDuration.toInt().toString()),
                        onSubmitted: (val) => onVibrationChanged(double.tryParse(val) ?? vibrationDuration),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: vibrationDuration.clamp(100.0, 2000.0),
                  min: 100,
                  max: 2000,
                  divisions: 38,
                  activeColor: theme.colorScheme.primary,
                  onChanged: onVibrationChanged,
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
