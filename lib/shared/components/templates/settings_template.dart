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

  final double minAngle;
  final double maxAngle;
  final ValueChanged<double> onMinAngleChanged;
  final ValueChanged<double> onMaxAngleChanged;

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
    required this.minAngle,
    required this.maxAngle,
    required this.onMinAngleChanged,
    required this.onMaxAngleChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(labelSensitivity, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${threshold.toInt()}°",
                        style: TextStyle(
                          color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                          fontWeight: FontWeight.bold,
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceSM),
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
          // Ideal Posture Range Section
          Text("Ideal Posture Readiness Range", style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ideal Angle Range", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "${minAngle.toInt()}° - ${maxAngle.toInt()}°",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceMD),
                RangeSlider(
                  values: RangeValues(minAngle.clamp(0.0, 90.0), maxAngle.clamp(0.0, 90.0)),
                  min: 0,
                  max: 90,
                  divisions: 90,
                  labels: RangeLabels("${minAngle.toInt()}°", "${maxAngle.toInt()}°"),
                  activeColor: theme.colorScheme.primary,
                  onChanged: (RangeValues values) {
                    if (values.start < values.end) {
                      onMinAngleChanged(values.start);
                      onMaxAngleChanged(values.end);
                    }
                  },
                ),
                const SizedBox(height: AppConstants.spaceSM),
                const Text(
                  "Configure the target device inclination angle (in degrees) required to pass the posture readiness check when starting a session.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),
          // Date Filter Section
          Text(labelDateFilter, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null 
                      ? labelClearFilter 
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedDate != null) ...[
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Colors.redAccent),
                        onPressed: onClearDate,
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: onSelectDate,
                      icon: Icon(Icons.calendar_today, size: 14, color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488)),
                      label: Text(
                        labelSelectDate,
                        style: TextStyle(
                          color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? const Color(0x4C2DD4BF) : const Color(0x4C0D9488)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(Icons.volume_up, size: 18, color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488)),
                      const SizedBox(width: 8),
                      Text(labelSoundAlerts, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  value: soundEnabled,
                  onChanged: onSoundToggled,
                  activeThumbColor: theme.colorScheme.primary,
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vibration, size: 18, color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488)),
                        const SizedBox(width: 8),
                        Text(labelVibrationMs, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${vibrationDuration.toInt()} ms",
                        style: TextStyle(
                          color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                          fontWeight: FontWeight.bold,
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceSM),
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
