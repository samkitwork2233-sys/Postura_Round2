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
}

class PostureNotifier extends StateNotifier<PostureState> {
  final BleService _bleService;
  final HistoryService _historyService;
  final AlertService _alertService;
  final SettingsService _settingsService;
  Timer? _sessionTimer;
  double _threshold = 15.0;

  PostureNotifier(this._bleService, this._historyService, this._alertService, this._settingsService) : super(PostureState()) {
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
      } else if (event == BluetoothConnectionState.disconnected && status != ConnectionStatus.searching) {
        status = ConnectionStatus.idle;
      }

      state = state.copyWith(
        isConnected: isConnected,
        connectionStatus: status,
        deviceName: isConnected ? _bleService.connectedDeviceName : null,
        deviceAddress: isConnected ? _bleService.connectedDeviceAddress : null,
      );
      if (isConnected) {
        if (_settingsService.hasConnectedOnce) {
          _bleService.sendThreshold(_threshold.toInt());
        } else {
          _settingsService.setHasConnectedOnce(true);
        }
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void setThreshold(double val) {
    _threshold = val;
    _bleService.sendThreshold(val.toInt());
  }



  void _handleData(String data) {
    // Expected format: "10.5,15.2" -> angle, deviation
    debugPrint("Received BLE Data: $data"); 
    try {
      final parts = data.trim().split(',');
      if (parts.length >= 2) {
        final angle = double.tryParse(parts[0]) ?? 0.0;
        final deviation = double.tryParse(parts[1]) ?? 0.0;
        
        bool currentlySlouching = deviation > _threshold;
        int newSlouchCount = state.slouchCount;
        
        if (currentlySlouching && !state.isSlouching) {
          newSlouchCount++;
          _alertService.triggerAlert();
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

  void _startTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        sessionSeconds: state.sessionSeconds + 1,
        goodSeconds: state.isSlouching ? state.goodSeconds : state.goodSeconds + 1,
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
      final avg = last5.map((e) => e.score).reduce((a, b) => a + b) / last5.length;
      state = state.copyWith(comparisonScore: avg.round());
    }
  }

  Future<void> stopSessionAndSave() async {
    if (_sessionTimer == null) return;
    
    final finalState = state;
    _stopTimer();

    if (finalState.sessionSeconds > 10) { // Save if session > 10s
      final session = SessionModel(
        date: DateTime.now().toString().split('.')[0], // Simple date format
        duration: _formatDuration(finalState.sessionSeconds),
        score: finalState.score,
        slouches: finalState.slouchCount,
        timestamp: DateTime.now(),
      );
      await _historyService.saveSession(session);
      _calculateComparison(); // Recalculate comparison after save
    }

    // Reset session metrics but keep connection status
    state = state.copyWith(
      slouchCount: 0,
      sessionSeconds: 0,
      goodSeconds: 0,
      badSeconds: 0,
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  Future<void> toggleConnection() async {
    if (state.isConnected) {
      await stopSessionAndSave();
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

final postureProvider = StateNotifierProvider<PostureNotifier, PostureState>((ref) {
  final historyService = ref.watch(historyServiceProvider);
  final alertService = ref.watch(alertServiceProvider);
  final settingsService = ref.watch(settingsServiceProvider);
  return PostureNotifier(
    ref.watch(bleServiceProvider), 
    historyService, 
    alertService, 
    settingsService,
  );
});
