import 'package:flutter/foundation.dart';
import '../models/objective.dart';
import '../services/storage_service.dart';

class ObjectiveProvider with ChangeNotifier {
  List<Objective> _objectives = [];

  List<Objective> get objectives => _objectives;

  ObjectiveProvider() {
    _loadObjectives();
  }

  void _loadObjectives() {
    _objectives = StorageService.objectivesBox.values.toList();
    _sortObjectives();
    notifyListeners();
  }

  void _sortObjectives() {
    _objectives.sort((a, b) => b.priority.compareTo(a.priority));
  }

  void addObjective(Objective objective) {
    StorageService.objectivesBox.put(objective.id, objective);
    _objectives.add(objective);
    _sortObjectives();
    notifyListeners();
  }

  void updateObjectiveCurrentAmount(String id, double addedAmount) {
    var obj = _objectives.firstWhere((o) => o.id == id);
    obj.currentAmount += addedAmount;
    if (obj.currentAmount > obj.targetAmount) {
      obj.currentAmount = obj.targetAmount;
    }
    StorageService.objectivesBox.put(obj.id, obj);
    notifyListeners();
  }

  void reorderObjectives(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Objective item = _objectives.removeAt(oldIndex);
    _objectives.insert(newIndex, item);
    
    // Update priorities based on new order
    // Recalculer l'index via 100 - i pour matcher le slider 0-100 de création
    for (int i = 0; i < _objectives.length; i++) {
      _objectives[i].priority = 100 - i;
      if (_objectives[i].priority < 0) _objectives[i].priority = 0;
      StorageService.objectivesBox.put(_objectives[i].id, _objectives[i]);
    }
    notifyListeners();
  }

  void deleteObjective(String id) {
    StorageService.objectivesBox.delete(id);
    _objectives.removeWhere((o) => o.id == id);
    notifyListeners();
  }
}
