import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/history_service.dart';
import '../models/session_model.dart';

class HistoryNotifier extends StateNotifier<List<SessionModel>> {
  final HistoryService _historyService;

  HistoryNotifier(this._historyService) : super([]) {
    _refresh();
  }

  void _refresh() {
    state = _historyService.getAllSessions();
  }

  Future<void> addSession(SessionModel session) async {
    await _historyService.saveSession(session);
    _refresh();
  }

  Future<void> clearAll() async {
    await _historyService.clearAll();
    _refresh();
  }

  Future<void> clearOlderThan(String period) async {
    DateTime? limit;
    final now = DateTime.now();
    
    switch (period) {
      case "1m": limit = now.subtract(const Duration(days: 30)); break;
      case "3m": limit = now.subtract(const Duration(days: 90)); break;
      case "6m": limit = now.subtract(const Duration(days: 180)); break;
      case "1y": limit = now.subtract(const Duration(days: 365)); break;
    }

    if (limit != null) {
      await _historyService.clearOlderThan(limit);
      _refresh();
    }
  }
}

class SessionStats {
  final int totalSessions;
  final int averageScore;
  final Duration totalDuration;
  final int totalSlouches;

  SessionStats({
    required this.totalSessions,
    required this.averageScore,
    required this.totalDuration,
    required this.totalSlouches,
  });

  factory SessionStats.empty() => SessionStats(
    totalSessions: 0,
    averageScore: 0,
    totalDuration: Duration.zero,
    totalSlouches: 0,
  );
}

final historyServiceProvider = Provider((ref) => HistoryService());
final historyProvider = StateNotifierProvider<HistoryNotifier, List<SessionModel>>((ref) {
  return HistoryNotifier(ref.watch(historyServiceProvider));
});

final historyDateFilterProvider = StateProvider<DateTime?>((ref) => null);

final filteredHistoryProvider = Provider<List<SessionModel>>((ref) {
  final history = ref.watch(historyProvider);
  final filterDate = ref.watch(historyDateFilterProvider);
  
  if (filterDate == null) return history;
  
  return history.where((s) => 
    s.timestamp.year == filterDate.year &&
    s.timestamp.month == filterDate.month &&
    s.timestamp.day == filterDate.day
  ).toList();
});

final sessionStatsProvider = Provider.family<SessionStats, DateTime>((ref, date) {
  final history = ref.watch(historyProvider);
  
  final daySessions = history.where((s) => 
    s.timestamp.year == date.year &&
    s.timestamp.month == date.month &&
    s.timestamp.day == date.day
  ).toList();

  if (daySessions.isEmpty) return SessionStats.empty();

  int totalScore = 0;
  int totalSlouches = 0;
  int totalSeconds = 0;

  for (var s in daySessions) {
    totalScore += s.score;
    totalSlouches += s.slouches;
    totalSeconds += _parseDuration(s.duration);
  }

  return SessionStats(
    totalSessions: daySessions.length,
    averageScore: (totalScore / daySessions.length).round(),
    totalDuration: Duration(seconds: totalSeconds),
    totalSlouches: totalSlouches,
  );
});

int _parseDuration(String duration) {
  try {
    final parts = duration.split(' ');
    int total = 0;
    for (var part in parts) {
      if (part.endsWith('m')) {
        total += int.parse(part.replaceAll('m', '')) * 60;
      } else if (part.endsWith('s')) {
        total += int.parse(part.replaceAll('s', ''));
      }
    }
    return total;
  } catch (_) {
    return 0;
  }
}
