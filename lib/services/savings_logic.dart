import '../models/expense.dart';
import '../models/savings_mode.dart';
import '../providers/objective_provider.dart';
import '../providers/user_provider.dart';
import '../providers/expense_provider.dart';

class SavingsLogic {
  final ObjectiveProvider objectiveProvider;
  final UserProvider userProvider;
  final ExpenseProvider expenseProvider;

  SavingsLogic({
    required this.objectiveProvider,
    required this.userProvider,
    required this.expenseProvider,
  });

  /// Processes an expense based on the current savings mode.
  double processExpense(Expense expense, SavingsMode mode, {double manualSavedAmount = 0.0}) {
    double savedAmount = 0.0;
    
    // RÈGLE MÉTIER : Arrondi supérieur
    if (mode == SavingsMode.automaticRoundup) {
      double rounded = expense.amount.ceilToDouble();
      savedAmount = rounded - expense.amount; 
    } else if (mode == SavingsMode.manual) {
      savedAmount = manualSavedAmount;
    }
    
    // Déduction (dépense + arrondi)
    double newBalance = (userProvider.user?.balance ?? 0) - expense.amount - savedAmount;

    // RÈGLE MÉTIER : Solde >= 0
    if (newBalance < 0) newBalance = 0;
    
    userProvider.updateBalance(newBalance);

    if (savedAmount > 0) {
      _distributeSavings(savedAmount);
    }
    
    return savedAmount;
  }

  /// Processes a reverse challenge explicit save
  void processReverseChallenge(double amountToSave) {
    double newBalance = (userProvider.user?.balance ?? 0) - amountToSave;
    if (newBalance < 0) newBalance = 0;
    userProvider.updateBalance(newBalance);
    _distributeSavings(amountToSave);
  }

  /// RÈGLE MÉTIER : 50%, 30%, 15%, 5%
  /// L'ordre (index) définit la priorité : [0]=1er, [1]=2e, etc.
  void _distributeSavings(double amount) {
    var objectives = objectiveProvider.objectives.where((o) => o.currentAmount < o.targetAmount).toList();
    if (objectives.isEmpty) return;
    
    if (objectives.length == 1) {
      objectiveProvider.updateObjectiveCurrentAmount(objectives[0].id, amount);
      return;
    }

    double totalWeight = 0;
    List<double> assignedWeights = [];
    
    for (int i = 0; i < objectives.length; i++) {
      if (i == 0) assignedWeights.add(50);
      else if (i == 1) assignedWeights.add(30);
      else if (i == 2) assignedWeights.add(15);
      else assignedWeights.add(5 / (objectives.length - 3));
    }

    totalWeight = assignedWeights.fold(0, (sum, w) => sum + w);

    for (int i = 0; i < objectives.length; i++) {
      double ratio = assignedWeights[i] / totalWeight;
      double amountForObj = amount * ratio;
      objectiveProvider.updateObjectiveCurrentAmount(objectives[i].id, amountForObj);
    }
  }
}
