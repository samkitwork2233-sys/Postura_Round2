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
  final VoidCallback onConnectPressed;
  final ConnectionStatus connectionStatus;

  final bool isSessionActive;
  final VoidCallback onStartSessionPressed;
  final VoidCallback onStopSessionPressed;
  final VoidCallback onDisconnectPressed;

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
    required this.onConnectPressed,
    required this.connectionStatus,
    required this.isSessionActive,
    required this.onStartSessionPressed,
    required this.onStopSessionPressed,
    required this.onDisconnectPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spaceLG),
          if (isConnected && deviceName != null) ...[
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
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
          ] else if (connectionStatus != ConnectionStatus.idle) ...[
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (connectionStatus == ConnectionStatus.searching ||
                      connectionStatus == ConnectionStatus.connecting)
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _getConnectionStatusText(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: connectionStatus == ConnectionStatus.error
                          ? Colors.redAccent
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
          ],

          Center(
            child: PostureIndicatorWidget(
              value: isSessionActive ? deviation / 30 : 0.0,
              threshold: threshold,
              isSafe: isSessionActive ? isSafe : true,
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),

          Row(
            children: [
              Expanded(
                child: GlassCard(
                  child: Column(
                    children: [
                      Text("Angle", style: theme.textTheme.bodySmall),
                      Text(
                        angleText,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      Text(
                        isSessionActive ? deviationText : "--",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMD),
          GlassCard(
            width: double.infinity,
            child: Column(
              children: [
                Text("Session Timer", style: theme.textTheme.bodySmall),
                Text(
                  timerText,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceMD),
          GlassCard(
            width: double.infinity,
            child: Column(
              children: [
                Text(labelScore, style: theme.textTheme.bodySmall),
                Text(
                  isSessionActive ? scoreText : "--",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceLG),
          if (isConnected) ...[
            Row(
              children: [
                Expanded(
                  child: isSessionActive
                      ? AnimatedButton(
                          onPressed: onStopSessionPressed,
                          color: Colors.redAccent.withValues(alpha: 0.8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stop, size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text("End & Save Session"),
                            ],
                          ),
                        )
                      : AnimatedButton(
                          onPressed: onStartSessionPressed,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Start Session"),
                            ],
                          ),
                        ),
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Expanded(
                  child: AnimatedButton(
                    onPressed: onDisconnectPressed,
                    color: Colors.grey.withValues(alpha: 0.2),
                    child: Text(
                      "Disconnect",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            AnimatedButton(
              onPressed: onConnectPressed,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Connect to Device"),
                ],
              ),
            ),
          ],
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
