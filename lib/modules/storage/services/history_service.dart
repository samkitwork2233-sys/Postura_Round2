import 'package:hive_flutter/hive_flutter.dart';
import '../models/session_model.dart';

class HistoryService {
  static const String boxName = "sessions";

  Future<void> init() async {
    Hive.registerAdapter(SessionModelAdapter());
    await Hive.openBox<SessionModel>(boxName);
  }

  Box<SessionModel> get _box => Hive.box<SessionModel>(boxName);

  List<SessionModel> getAllSessions() {
    return _box.values.toList().reversed.toList();
  }

  Future<void> saveSession(SessionModel session) async {
    await _box.add(session);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> clearOlderThan(DateTime date) async {
    final keysToDelete = _box.keys.where((key) {
      final session = _box.get(key);
      return session != null && session.timestamp.isBefore(date);
    }).toList();
    
    await _box.deleteAll(keysToDelete);
  }
}
