import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 2)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  double roundedSavedAmount; // How much was saved via roundup for this expense

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.roundedSavedAmount = 0.0,
  });
}
