import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double balance;

  @HiveField(2)
  double monthlyIncome;

  User({
    required this.name,
    this.balance = 0.0,
    this.monthlyIncome = 0.0,
  });
}
