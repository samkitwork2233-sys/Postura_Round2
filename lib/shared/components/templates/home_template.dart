import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../ui/glass_card.dart';
import '../ui/posture_indicator_widget.dart';
import '../ui/animated_button.dart';
import 'package:postura/modules/posture/core/posture_provider.dart';

class HomeTemplate extends StatelessWidget {
  final String title;
  final String statusText;
  final double deviation;
  final double threshold;
  final bool isSafe;
  final String angleText;
  final String deviationText;
  final String timerText;
  final String scoreText;
  final String labelScore;
  final bool isConnected;
  final String? deviceName;
  final String? deviceAddress;
  final String connectButtonText;
  final VoidCallback onConnectPressed;
  final ConnectionStatus connectionStatus;

  const HomeTemplate({
    required this.title,
    required this.statusText,
    required this.deviation,
    required this.threshold,
    required this.isSafe,
    required this.angleText,
    required this.deviationText,
    required this.timerText,
    required this.scoreText,
    required this.labelScore,
    required this.isConnected,
    this.deviceName,
    this.deviceAddress,
    required this.connectButtonText,
    required this.onConnectPressed,
    required this.connectionStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
        const SizedBox(height: AppConstants.spaceLG),
        Center(
          child: PostureIndicatorWidget(
            value: deviation / 30, // Simplified normalization for demo
            threshold: threshold,
            isSafe: isSafe,
          ),
        ),
        if (isConnected && deviceName != null) ...[
          const SizedBox(height: AppConstants.spaceMD),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bluetooth_connected, size: 14, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    deviceName!,
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ] else if (connectionStatus != ConnectionStatus.idle) ...[
          const SizedBox(height: AppConstants.spaceMD),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (connectionStatus == ConnectionStatus.searching || connectionStatus == ConnectionStatus.connecting)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                const SizedBox(width: 8),
                Text(
                  _getConnectionStatusText(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: connectionStatus == ConnectionStatus.error ? Colors.redAccent : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppConstants.spaceXL),
        // Metrics Grid
        Row(
          children: [
            Expanded(
              child: GlassCard(
                child: Column(
                  children: [
                    Text("Angle", style: theme.textTheme.bodySmall),
                    Text(angleText, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spaceMD),
            Expanded(
              child: GlassCard(
                child: Column(
                  children: [
                    Text("Deviation", style: theme.textTheme.bodySmall),
                    Text(deviationText, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spaceMD),
        // Timer Card
        GlassCard(
          width: double.infinity,
          child: Column(
            children: [
              Text("Session Timer", style: theme.textTheme.bodySmall),
              Text(timerText, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spaceMD),
        // Score Card
        GlassCard(
          width: double.infinity,
          child: Column(
            children: [
              Text(labelScore, style: theme.textTheme.bodySmall),
              Text(scoreText, style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold, 
                color: theme.colorScheme.primary,
              )),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spaceMD),
        // Connect Button
        AnimatedButton(
          onPressed: onConnectPressed,
          color: isConnected ? Colors.redAccent.withValues(alpha: 0.8) : null,
          child: Text(connectButtonText),
        ),
        const SizedBox(height: AppConstants.spaceXL),
      ],
    ),
  );
}

  String _getConnectionStatusText() {
    switch (connectionStatus) {
      case ConnectionStatus.searching:
        return "Searching for Postura...";
      case ConnectionStatus.error:
        return "Connection Failed";
      default:
        return "";
    }
  }
}
