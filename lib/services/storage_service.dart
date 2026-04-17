import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../models/objective.dart';
import '../models/expense.dart';
import '../models/savings_mode.dart';

class StorageService {
  static const String userBoxName = 'userBox';
  static const String objectivesBoxName = 'objectivesBox';
  static const String expensesBoxName = 'expensesBox';
  static const String settingsBoxName = 'settingsBox';
  static const String budgetsBoxName = 'budgetsBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters safely for hot-restart
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ObjectiveAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ExpenseAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(SavingsModeAdapter());

    // Open Boxes
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox<Objective>(objectivesBoxName);
    await Hive.openBox<Expense>(expensesBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<double>(budgetsBoxName);

    var sb = Hive.box(settingsBoxName);
    if (sb.get('demo_v3_seeded') != true) {
      await clearAll();
      await _seedDemoData();
      sb.put('demo_v3_seeded', true);
    }
  }

  static Future<void> _seedDemoData() async {
    // 1. Mode actif: Arrondi par défaut
    settingsBox.put('savingsModeIndex', SavingsMode.automaticRoundup.index);

    // 2. Utilisateur (Freelance sans revenu fixe)
    userBox.put(0, User(name: "Sami", balance: 142.75, monthlyIncome: 1100.0));

    // 3. Objectifs d'épargne (Contexte métier indépendant / Gig worker)
    objectivesBox.put("obj1", Objective(id: "obj1", title: "Réparation Moto", targetAmount: 150.0, currentAmount: 43.50, targetDate: DateTime.now().add(const Duration(days: 14))));
    objectivesBox.put("obj2", Objective(id: "obj2", title: "Caisse de Flottement", targetAmount: 300.0, currentAmount: 21.00, targetDate: DateTime.now().add(const Duration(days: 60))));
    objectivesBox.put("obj3", Objective(id: "obj3", title: "Nouveau Casque", targetAmount: 80.0, currentAmount: 6.25, targetDate: DateTime.now().add(const Duration(days: 30))));

    // 4. Limites de Budgets (Configurées par Sami)
    budgetsBox.put("Courses", 150.0);
    budgetsBox.put("Transport", 80.0);
    budgetsBox.put("Autre", 60.0);

    // 5. Historique de Dépenses TAW (Micro-transactions & Arrondis massifs)
    DateTime now = DateTime.now();
    var uuid = const Uuid();
    
    List<Expense> mockExpenses = [
      Expense(id: uuid.v4(), amount: 3.20, category: "Transport", date: now.subtract(const Duration(hours: 4))),
      Expense(id: uuid.v4(), amount: 7.45, category: "Autre", date: now.subtract(const Duration(hours: 18))),
      Expense(id: uuid.v4(), amount: 22.80, category: "Courses", date: now.subtract(const Duration(days: 1))),
      Expense(id: uuid.v4(), amount: 2.10, category: "Transport", date: now.subtract(const Duration(days: 2))),
      Expense(id: uuid.v4(), amount: 15.00, category: "Médical", date: now.subtract(const Duration(days: 3))),
      Expense(id: uuid.v4(), amount: 6.60, category: "Autre", date: now.subtract(const Duration(days: 4))),
      Expense(id: uuid.v4(), amount: 48.30, category: "Courses", date: now.subtract(const Duration(days: 7))),
      Expense(id: uuid.v4(), amount: 110.00, category: "Loyer", date: now.subtract(const Duration(days: 15))),

      // Dépenses du mois précédent
      Expense(id: uuid.v4(), amount: 14.50, category: "Loisirs", date: DateTime(now.year, now.month - 1, 28)),
      Expense(id: uuid.v4(), amount: 8.25, category: "Autre", date: DateTime(now.year, now.month - 1, 25)),
      Expense(id: uuid.v4(), amount: 31.80, category: "Courses", date: DateTime(now.year, now.month - 1, 20)),
    ];

    // Calcul immédiat des arrondis pour le MVP
    for (var e in mockExpenses) {
      if (e.amount > 0 && e.amount % 1 != 0) {
        e.roundedSavedAmount = e.amount.ceilToDouble() - e.amount;
      } else {
        e.roundedSavedAmount = 0.0;
      }
      expensesBox.put(e.id, e);
    }
  }

  static Box<User> get userBox => Hive.box<User>(userBoxName);
  static Box<Objective> get objectivesBox => Hive.box<Objective>(objectivesBoxName);
  static Box<Expense> get expensesBox => Hive.box<Expense>(expensesBoxName);
  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box<double> get budgetsBox => Hive.box<double>(budgetsBoxName);

  static Future<void> clearAll() async {
    await userBox.clear();
    await objectivesBox.clear();
    await expensesBox.clear();
    await settingsBox.clear();
  }
}
