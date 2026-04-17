import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/expense_provider.dart';
import '../providers/savings_provider.dart';
import '../services/savings_logic.dart';
import '../providers/objective_provider.dart';
import '../providers/user_provider.dart';
import '../models/expense.dart';
import '../models/savings_mode.dart';
import '../utils/constants.dart';
import '../widgets/category_grid.dart';
import '../widgets/notification_popup.dart';
import '../services/storage_service.dart';
import '../services/ai_recommendation_service.dart';

class DeclareExpenseScreen extends StatefulWidget {
  const DeclareExpenseScreen({super.key});

  @override
  State<DeclareExpenseScreen> createState() => _DeclareExpenseScreenState();
}

class _DeclareExpenseScreenState extends State<DeclareExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _manualSavingsController = TextEditingController();
  String _selectedCategory = "Courses";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Déclarer une dépense", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.alert,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppStyles.borderRadius,
                border: Border.all(color: AppColors.alert.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                   const Text("TND", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                   const SizedBox(width: 16),
                   Expanded(
                     child: TextField(
                       controller: _amountController,
                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
                       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.alert),
                       decoration: const InputDecoration(
                         border: InputBorder.none,
                         hintText: "0.00",
                       ),
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Catégorie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
            const SizedBox(height: 16),
            CategoryGrid(
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            if (_selectedCategory == "Autre") ...[
              const SizedBox(height: 16),
              TextField(
                controller: _customCategoryController,
                decoration: const InputDecoration(
                  labelText: "Spécifiez la dépense",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryValue, width: 2)),
                ),
              ),
            ],
            if (context.watch<SavingsProvider>().currentMode == SavingsMode.manual) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _manualSavingsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Montant à épargner sur cette dépense (TND)",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryValue, width: 2)),
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.alert,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
              ),
              child: const Text("Ajouter la dépense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _addExpense() {
    if (_amountController.text.isEmpty) return;
    
    double? rawAmount = double.tryParse(_amountController.text);
    if (rawAmount == null || rawAmount <= 0) return;

    final savingsMode = context.read<SavingsProvider>().currentMode;
    
    // Core providers
    final ep = context.read<ExpenseProvider>();
    final op = context.read<ObjectiveProvider>();
    final userp = context.read<UserProvider>();
    
    final logic = SavingsLogic(
      objectiveProvider: op,
      userProvider: userp,
      expenseProvider: ep,
    );

    String finalCategory = _selectedCategory == "Autre" && _customCategoryController.text.trim().isNotEmpty
        ? _customCategoryController.text.trim()
        : _selectedCategory;

    Expense expense = Expense(
      id: Uuid().v4(),
      amount: rawAmount,
      category: finalCategory,
      date: DateTime.now(),
    );

    double manualSaved = 0.0;
    if (savingsMode == SavingsMode.manual && _manualSavingsController.text.trim().isNotEmpty) {
      manualSaved = double.tryParse(_manualSavingsController.text.trim()) ?? 0.0;
    }

    double savedAmount = logic.processExpense(expense, savingsMode, manualSavedAmount: manualSaved);
    expense.roundedSavedAmount = savedAmount;
    
    ep.addExpense(expense);

    var budgetBox = StorageService.budgetsBox;
    if (budgetBox.containsKey(finalCategory)) {
      double limit = budgetBox.get(finalCategory)!;
      DateTime now = DateTime.now();
      double categorySpentThisMonth = ep.expenses
          .where((e) => e.category == finalCategory && e.date.month == now.month && e.date.year == now.year)
          .fold(0.0, (sum, e) => sum + e.amount);

      if (categorySpentThisMonth > limit) {
        String advice = AiRecommendationService.getBudgetLimitAdvice(finalCategory, limit);
        NotificationPopup.show(context, "Alerte Dépassement Budget 🚨", advice, isError: true);
      } else {
        if (savedAmount > 0) NotificationPopup.show(context, "Arrondi automatique !", "+${savedAmount.toStringAsFixed(2)} TND ajoutés à ton épargne 🎉");
        else NotificationPopup.show(context, "Succès", "Dépense ajoutée.");
      }
    } else {
      if (savedAmount > 0) NotificationPopup.show(context, "Arrondi automatique !", "+${savedAmount.toStringAsFixed(2)} TND ajoutés à ton épargne 🎉");
      else NotificationPopup.show(context, "Succès", "Dépense ajoutée.");
    }

    Navigator.pop(context);
  }
}
