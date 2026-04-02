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

final historyServiceProvider = Provider((ref) => HistoryService());
final historyProvider = StateNotifierProvider<HistoryNotifier, List<SessionModel>>((ref) {
  return HistoryNotifier(ref.watch(historyServiceProvider));
});
