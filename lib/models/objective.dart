import 'package:hive/hive.dart';

part 'objective.g.dart';

@HiveType(typeId: 1)
class Objective extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  double currentAmount;

  @HiveField(4)
  DateTime targetDate;

  @HiveField(5)
  int priority; // 0 to 100

  Objective({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.targetDate,
    this.priority = 50,
  });
}
