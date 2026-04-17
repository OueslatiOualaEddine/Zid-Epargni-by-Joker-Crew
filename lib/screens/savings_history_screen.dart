import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/savings_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/objective_provider.dart';
import '../models/savings_mode.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';

class SavingsHistoryScreen extends StatelessWidget {
  const SavingsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savingsProvider = context.watch<SavingsProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();
    final objectiveProvider = context.watch<ObjectiveProvider>();
    
    final mode = savingsProvider.currentMode;
    double totalSaved = objectiveProvider.objectives.fold(0.0, (sum, o) => sum + o.currentAmount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Détails de l'épargne", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(context, mode, expenseProvider, totalSaved),
    );
  }

  Widget _buildBody(BuildContext context, SavingsMode mode, ExpenseProvider ep, double totalSaved) {
    if (mode == SavingsMode.reverseChallenge) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_clock, size: 80, color: AppColors.primaryValue),
              const SizedBox(height: 16),
              const Text("Défi Inversé Actif", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const SizedBox(height: 16),
              Text(
                "Montant total bloqué : ${totalSaved.toStringAsFixed(2)} TND\n\nCe mode est prélevé de façon brute. Il n'y a pas de log par dépôt.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    if (mode == SavingsMode.manual) {
      var budgetBox = StorageService.budgetsBox;
      DateTime now = DateTime.now();
      
      List<Widget> categoryWidgets = [];
      double totalLeft = 0.0;

      for (var cat in budgetBox.keys) {
        if (cat is String) {
          double limit = budgetBox.get(cat) ?? 0.0;
          double spent = ep.expenses
              .where((e) => e.category == cat && e.date.month == now.month && e.date.year == now.year)
              .fold(0.0, (sum, e) => sum + e.amount);
          
          double left = limit - spent;
          if (left < 0) left = 0;
          
          totalLeft += left;

          categoryWidgets.add(
            Card(
              color: AppColors.surface,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Plafond: $limit TND | Dépensé: $spent TND"),
                trailing: Text(
                  "Reste: ${left.toStringAsFixed(2)} TND",
                  style: TextStyle(color: left > 0 ? AppColors.primaryValue : AppColors.alert, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
      }

      if (categoryWidgets.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("Aucun budget défini. Rends-toi dans les limites de budget pour configurer des plafonds et voir l'épargne potentielle !", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
          )
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryValue.withOpacity(0.1),
              borderRadius: AppStyles.borderRadius,
            ),
            child: Column(
              children: [
                const Text("Potentiel d'Épargne Restant", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text("${totalLeft.toStringAsFixed(2)} TND", style: const TextStyle(color: AppColors.primaryValue, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Détail par catégorie :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...categoryWidgets,
        ],
      );
    }

    var savingsList = ep.expenses.where((e) => e.roundedSavedAmount > 0).toList();
    
    if (savingsList.isEmpty) {
      return const Center(
        child: Text("Aucune épargne enregistrée pour le moment.", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savingsList.length,
      itemBuilder: (context, index) {
        var expense = savingsList[index];
        return Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryValue.withOpacity(0.1),
              child: const Icon(Icons.savings, color: AppColors.primaryValue),
            ),
            title: Text(expense.category, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
            subtitle: Text("Dépense: ${expense.amount.toStringAsFixed(2)} TND\nDate: ${DateFormat('dd/MM/yyyy HH:mm').format(expense.date)}"),
            trailing: Text(
              "+ ${expense.roundedSavedAmount.toStringAsFixed(2)} TND",
              style: const TextStyle(color: AppColors.primaryValue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
