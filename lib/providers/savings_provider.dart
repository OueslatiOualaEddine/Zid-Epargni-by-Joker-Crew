import 'package:flutter/foundation.dart';
import '../models/savings_mode.dart';
import '../services/storage_service.dart';

class SavingsProvider with ChangeNotifier {
  SavingsMode _currentMode = SavingsMode.manual;

  SavingsMode get currentMode => _currentMode;

  SavingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    int index = StorageService.settingsBox.get('savingsModeIndex', defaultValue: SavingsMode.manual.index);
    _currentMode = SavingsMode.values[index];
    notifyListeners();
  }

  void setMode(SavingsMode mode) {
    _currentMode = mode;
    StorageService.settingsBox.put('savingsModeIndex', mode.index);
    notifyListeners();
  }
}
