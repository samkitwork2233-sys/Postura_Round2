import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/modules/posture/core/posture_provider.dart';
import 'package:postura/modules/posture/actions/index.dart';
import 'package:postura/shared/components/templates/home_template.dart';
import 'package:postura/shared/components/templates/common_page_shell.dart';
import 'package:postura/shared/components/ui/theme_toggle.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/shared/constants/strings/index.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postureState = ref.watch(postureProvider);
    final postureNotifier = ref.read(postureProvider.notifier);
    final connectionActions = ref.read(connectionActionsProvider);

    final settings = ref.watch(settingsProvider);

    return CommonPageShell(
      title: HomeStrings.dashboard,
      themeToggle: ThemeToggle(
        isDark: settings.themeMode == ThemeMode.dark,
        onToggle: () => ref.read(settingsProvider.notifier).toggleTheme(),
      ),
      child: HomeTemplate(
        title: HomeStrings.dashboard,
        statusText: postureState.isSessionActive
            ? (postureState.isSlouching
                ? HomeStrings.badPosture
                : HomeStrings.goodPosture)
            : "Ready to Start Session",
        deviation: postureState.deviation,
        threshold: settings.threshold,
        isSafe: !postureState.isSlouching,
        angleText: "${postureState.angle.toStringAsFixed(1)}°",
        deviationText: "${postureState.deviation.toStringAsFixed(1)}°",
        timerText: _formatDuration(postureState.sessionSeconds),
        scoreText: "${postureState.score}%",
        labelScore: HomeStrings.currentScore,
        isConnected: postureState.isConnected,
        deviceName: postureState.deviceName,
        deviceAddress: postureState.deviceAddress,
        onConnectPressed: () async {
          final readyToConnect = await connectionActions.ensurePermissions(
            context,
          );
          if (readyToConnect) {
            postureNotifier.toggleConnection();
          }
        },
        connectionStatus: postureState.connectionStatus,
        isSessionActive: postureState.isSessionActive,
        isCalibrating: postureState.isCalibrating,
        calibrationCountdown: postureState.calibrationCountdown,
        calibrationError: postureState.calibrationError,
        onStartSessionPressed: () => postureNotifier.startCalibration(),
        onStopSessionPressed: () => postureNotifier.stopSessionAndSave(),
        onCancelCalibrationPressed: () => postureNotifier.cancelCalibration(),
        onDisconnectPressed: () => postureNotifier.toggleConnection(),
        minAngle: settings.minAngle,
        maxAngle: settings.maxAngle,
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
