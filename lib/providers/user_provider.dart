import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  UserProvider() {
    _loadUser();
  }

  void _loadUser() {
    if (StorageService.userBox.isNotEmpty) {
      _user = StorageService.userBox.get(0);
    } else {
      // Mock default user for MVP
      _user = User(name: "Ali", balance: 50.0, monthlyIncome: 1000.0);
      StorageService.userBox.put(0, _user!);
    }
    notifyListeners();
  }

  void updateBalance(double newBalance) {
    if (_user != null) {
      _user!.balance = newBalance < 0 ? 0 : newBalance;
      StorageService.userBox.put(0, _user!);
      notifyListeners();
    }
  }

  void updateIncome(double income) {
    if (_user != null) {
      _user!.monthlyIncome = income;
      StorageService.userBox.put(0, _user!);
      notifyListeners();
    }
  }
}
