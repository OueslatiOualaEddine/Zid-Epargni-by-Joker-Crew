import 'package:hive/hive.dart';

part 'savings_mode.g.dart';

@HiveType(typeId: 3)
enum SavingsMode {
  @HiveField(0)
  manual,

  @HiveField(1)
  automaticRoundup,

  @HiveField(2)
  reverseChallenge,
}
