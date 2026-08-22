import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:postura/modules/posture/services/ble_service.dart';
import 'package:postura/modules/storage/services/history_service.dart';
import 'package:postura/modules/storage/core/history_provider.dart';
import 'package:postura/modules/storage/models/session_model.dart';
import 'package:postura/shared/lib/alert_service.dart';
import 'package:postura/modules/storage/services/settings_service.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';

enum ConnectionStatus { idle, searching, connecting, connected, error }

class PostureState {
  final double angle;
  final double deviation;
  final int slouchCount;
  final bool isSlouching;
  final int sessionSeconds;
  final int goodSeconds;
  final int badSeconds;
  final bool isConnected;
  final List<double> deviationHistory;
  final int? comparisonScore;
  final ConnectionStatus connectionStatus;
  final String? deviceName;
  final String? deviceAddress;
  final bool isSessionActive;
  final double? baseAngle;
  final bool isCalibrating;
  final int calibrationCountdown;
  final String? calibrationError;

  PostureState({
    this.angle = 0,
    this.deviation = 0,
    this.slouchCount = 0,
    this.isSlouching = false,
    this.sessionSeconds = 0,
    this.goodSeconds = 0,
    this.badSeconds = 0,
    this.isConnected = false,
    this.connectionStatus = ConnectionStatus.idle,
    this.deviationHistory = const [],
    this.comparisonScore,
    this.deviceName,
    this.deviceAddress,
    this.isSessionActive = false,
    this.baseAngle,
    this.isCalibrating = false,
    this.calibrationCountdown = 0,
    this.calibrationError,
  });

  PostureState copyWith({
    double? angle,
    double? deviation,
    int? slouchCount,
    bool? isSlouching,
    int? sessionSeconds,
    int? goodSeconds,
    int? badSeconds,
    bool? isConnected,
    ConnectionStatus? connectionStatus,
    List<double>? deviationHistory,
    int? comparisonScore,
    String? deviceName,
    String? deviceAddress,
    bool? isSessionActive,
    double? baseAngle,
    bool? isCalibrating,
    int? calibrationCountdown,
    String? calibrationError,
    bool clearBaseAngle = false,
    bool clearCalibrationError = false,
  }) {
    return PostureState(
      angle: angle ?? this.angle,
      deviation: deviation ?? this.deviation,
      slouchCount: slouchCount ?? this.slouchCount,
      isSlouching: isSlouching ?? this.isSlouching,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
      goodSeconds: goodSeconds ?? this.goodSeconds,
      badSeconds: badSeconds ?? this.badSeconds,
      isConnected: isConnected ?? this.isConnected,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      deviationHistory: deviationHistory ?? this.deviationHistory,
      comparisonScore: comparisonScore ?? this.comparisonScore,
      deviceName: deviceName ?? this.deviceName,
      deviceAddress: deviceAddress ?? this.deviceAddress,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      baseAngle: clearBaseAngle ? null : (baseAngle ?? this.baseAngle),
      isCalibrating: isCalibrating ?? this.isCalibrating,
      calibrationCountdown: calibrationCountdown ?? this.calibrationCountdown,
      calibrationError: clearCalibrationError ? null : (calibrationError ?? this.calibrationError),
    );
  }

  int get score {
    final total = sessionSeconds; // Use total session time
    if (total == 0) return 100;

    // Base score: percentage of time in good posture
    final double timeScore = (goodSeconds / total) * 100;

    // Penalty: penalize each slouch event
    final double penalty = slouchCount * 2.0;

    return (timeScore - penalty).clamp(0, 100).round();
  }
}class PostureNotifier extends StateNotifier<PostureState> {
  final BleService _bleService;
  final HistoryService _historyService;
  final AlertService _alertService;
  final SettingsService _settingsService;
  Timer? _sessionTimer;
  Timer? _calibrationTimer;
  double _threshold = 15.0;

  final VoidCallback? onConnected;

  PostureNotifier(
    this._bleService,
    this._historyService,
    this._alertService,
    this._settingsService, {
    this.onConnected,
  }) : super(PostureState()) {
    _threshold = _settingsService.threshold;
    _init();
  }

  void _init() {
    _calculateComparison();
    _bleService.dataStream.listen(_handleData);
    _bleService.connectionState.listen((event) {
      final isConnected = event == BluetoothConnectionState.connected;
      ConnectionStatus status = state.connectionStatus;
      if (isConnected) {
        status = ConnectionStatus.connected;
      } else if (event == BluetoothConnectionState.disconnected &&
          status != ConnectionStatus.searching) {
        status = ConnectionStatus.idle;
      }

      state = state.copyWith(
        isConnected: isConnected,
        connectionStatus: status,
        deviceName: isConnected ? _bleService.connectedDeviceName : null,
        deviceAddress: isConnected ? _bleService.connectedDeviceAddress : null,
      );
      if (isConnected) {
        _threshold = 10.0;
        _bleService.sendThreshold(10);
        onConnected?.call();
      } else {
        _stopTimer();
        _calibrationTimer?.cancel();
        state = state.copyWith(
          isSessionActive: false,
          isCalibrating: false,
          calibrationCountdown: 0,
          clearBaseAngle: true,
          clearCalibrationError: true,
          slouchCount: 0,
          sessionSeconds: 0,
          goodSeconds: 0,
          badSeconds: 0,
        );
      }
    });
  }

  void setThreshold(double val) {
    _threshold = val;
    _bleService.sendThreshold(val.toInt());
  }

  void _handleData(String data) {
    debugPrint("Received BLE Data: $data");
    try {
      final parts = data.trim().split(',');
      if (parts.length >= 2) {
        final angle = double.tryParse(parts[0]) ?? 0.0;
        double deviation = double.tryParse(parts[1]) ?? 0.0;
        
        if (state.isSessionActive && state.baseAngle != null) {
          deviation = (angle - state.baseAngle!).abs();
        }

        bool currentlySlouching = deviation > _threshold;
        int newSlouchCount = state.slouchCount;

        if (state.isSessionActive) {
          if (currentlySlouching && !state.isSlouching) {
            newSlouchCount++;
            _alertService.triggerAlert();
          }
        } else {
          currentlySlouching = false;
        }

        final newHistory = List<double>.from(state.deviationHistory);
        if (newHistory.length >= 40) newHistory.removeAt(0);
        newHistory.add(deviation);

        state = state.copyWith(
          angle: angle,
          deviation: deviation,
          slouchCount: newSlouchCount,
          isSlouching: currentlySlouching,
          deviationHistory: newHistory,
        );
      }
    } catch (e) {
      debugPrint("Data parsing error: $e for data: $data");
    }
  }

  Future<void> startCalibration() async {
    if (!state.isConnected) return;

    _calibrationTimer?.cancel();
    state = state.copyWith(
      isCalibrating: true,
      calibrationCountdown: 3,
      clearCalibrationError: true,
      clearBaseAngle: true,
    );

    _calibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final currentCountdown = state.calibrationCountdown - 1;
      if (currentCountdown > 0) {
        state = state.copyWith(calibrationCountdown: currentCountdown);
      } else {
        _calibrationTimer?.cancel();
        final finalAngle = state.angle;
        final minVal = _settingsService.minAngle;
        final maxVal = _settingsService.maxAngle;

        if (finalAngle >= minVal && finalAngle <= maxVal) {
          state = state.copyWith(
            isCalibrating: false,
            calibrationCountdown: 0,
            baseAngle: finalAngle,
            isSessionActive: true,
            clearCalibrationError: true,
          );
          await _bleService.sendBaseAngle(finalAngle.toInt());
          _startTimer();
        } else {
          state = state.copyWith(
            isCalibrating: false,
            calibrationCountdown: 0,
            calibrationError: "Your posture angle was ${finalAngle.toStringAsFixed(1)}°. It must be between ${minVal.toStringAsFixed(0)}° and ${maxVal.toStringAsFixed(0)}° to start. Please adjust your posture and try again.",
          );
        }
      }
    });
  }

  void cancelCalibration() {
    _calibrationTimer?.cancel();
    state = state.copyWith(
      isCalibrating: false,
      calibrationCountdown: 0,
      clearCalibrationError: true,
    );
  }

  void _startTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        sessionSeconds: state.sessionSeconds + 1,
        goodSeconds: state.isSlouching
            ? state.goodSeconds
            : state.goodSeconds + 1,
        badSeconds: state.isSlouching ? state.badSeconds + 1 : state.badSeconds,
      );
    });
  }

  void _stopTimer() {
    _sessionTimer?.cancel();
  }

  void _calculateComparison() {
    final history = _historyService.getAllSessions();
    if (history.isNotEmpty) {
      final last5 = history.take(5).toList();
      final avg =
          last5.map((e) => e.score).reduce((a, b) => a + b) / last5.length;
      state = state.copyWith(comparisonScore: avg.round());
    }
  }

  Future<void> stopSessionAndSave() async {
    if (!state.isSessionActive) return;

    final finalState = state;
    _stopTimer();

    if (finalState.sessionSeconds > 10) {
      final session = SessionModel(
        date: DateTime.now().toString().split('.')[0],
        duration: _formatDuration(finalState.sessionSeconds),
        score: finalState.score,
        slouches: finalState.slouchCount,
        timestamp: DateTime.now(),
      );
      await _historyService.saveSession(session);
      _calculateComparison();
    }

    state = state.copyWith(
      isSessionActive: false,
      clearBaseAngle: true,
      slouchCount: 0,
      sessionSeconds: 0,
      goodSeconds: 0,
      badSeconds: 0,
      clearCalibrationError: true,
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  Future<void> toggleConnection() async {
    if (state.isConnected) {
      if (state.isSessionActive) {
        await stopSessionAndSave();
      }
      await _bleService.disconnect();
      state = state.copyWith(connectionStatus: ConnectionStatus.idle);
    } else {
      state = state.copyWith(connectionStatus: ConnectionStatus.searching);
      try {
        final success = await _bleService.connect();
        if (!success) {
          state = state.copyWith(connectionStatus: ConnectionStatus.error);
        }
      } catch (e) {
        state = state.copyWith(connectionStatus: ConnectionStatus.error);
      }
    }
  }
}
// Providers
final bleServiceProvider = Provider((ref) => BleService());
final alertServiceProvider = Provider((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return AlertService(settingsService);
});

final postureProvider = StateNotifierProvider<PostureNotifier, PostureState>((
  ref,
) {
  final historyService = ref.watch(historyServiceProvider);
  final alertService = ref.watch(alertServiceProvider);
  final settingsService = ref.watch(settingsServiceProvider);
  return PostureNotifier(
    ref.watch(bleServiceProvider),
    historyService,
    alertService,
    settingsService,
    onConnected: () {
      ref.read(settingsProvider.notifier).setThreshold(10.0);
    },
  );
});
