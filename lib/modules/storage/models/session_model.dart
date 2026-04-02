import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 0)
class SessionModel extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String duration;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final int slouches;

  @HiveField(4)
  final DateTime timestamp;

  SessionModel({
    required this.date,
    required this.duration,
    required this.score,
    required this.slouches,
    required this.timestamp,
  });
}
