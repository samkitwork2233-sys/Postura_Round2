import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../ui/glass_card.dart';
import '../ui/animated_button.dart';

class SettingsTemplate extends StatelessWidget {
  final double threshold;
  final ValueChanged<double> onThresholdChanged;
  final VoidCallback onCalibrate;
  final double vibrationDuration;
  final ValueChanged<double> onVibrationChanged;
  final bool soundEnabled;
  final ValueChanged<bool> onSoundToggled;
  final String labelThreshold;
  final String labelSensitivity;
  final String descThreshold;
  final String labelCalibration;
  final String descCalibration;
  final String labelCalibrateBtn;
  final String labelAlertFeedback;
  final String labelSoundAlerts;
  final String labelVibrationMs;

  const SettingsTemplate({
    required this.threshold,
    required this.onThresholdChanged,
    required this.onCalibrate,
    required this.vibrationDuration,
    required this.onVibrationChanged,
    required this.soundEnabled,
    required this.onSoundToggled,
    required this.labelThreshold,
    required this.labelSensitivity,
    required this.descThreshold,
    required this.labelCalibration,
    required this.descCalibration,
    required this.labelCalibrateBtn,
    required this.labelAlertFeedback,
    required this.labelSoundAlerts,
    required this.labelVibrationMs,
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
          // Calibration
          Text(labelCalibration, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.spaceSM),
          GlassCard(
            width: double.infinity,
            child: Column(
              children: [
                Text(descCalibration),
                const SizedBox(height: AppConstants.spaceMD),
                AnimatedButton(
                  onPressed: onCalibrate,
                  child: Text(labelCalibrateBtn),
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
