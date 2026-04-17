import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    _loadExpenses();
  }

  void _loadExpenses() {
    _expenses = StorageService.expensesBox.values.toList();
    if (_expenses.isEmpty) {
      _seedMockExpenses();
    } else {
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  void _seedMockExpenses() {
    DateTime now = DateTime.now();
    var mocks = [
      Expense(id: Uuid().v4(), amount: 15.50, category: "Courses", date: now.subtract(const Duration(days: 1))),
      Expense(id: Uuid().v4(), amount: 4.20, category: "Transport", date: now.subtract(const Duration(days: 2))),
      Expense(id: Uuid().v4(), amount: 120.0, category: "Loyer", date: now.subtract(const Duration(days: 5))),
      Expense(id: Uuid().v4(), amount: 35.0, category: "Loisirs", date: now.subtract(const Duration(days: 15))),
      Expense(id: Uuid().v4(), amount: 12.65, category: "Courses", date: DateTime(now.year, now.month - 1, 14)),
      Expense(id: Uuid().v4(), amount: 8.90, category: "Médical", date: DateTime(now.year, now.month - 1, 22)),
    ];
    for (var m in mocks) {
      StorageService.expensesBox.put(m.id, m);
      _expenses.add(m);
    }
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void addExpense(Expense expense) {
    StorageService.expensesBox.put(expense.id, expense);
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  double get totalExpensesCurrentMonth {
    var now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}
