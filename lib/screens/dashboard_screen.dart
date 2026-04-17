import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

import '../providers/objective_provider.dart';
import '../providers/savings_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';
import '../services/ai_recommendation_service.dart';
import '../models/savings_mode.dart';
import '../utils/constants.dart';
import '../widgets/objective_card.dart';
import '../widgets/notification_popup.dart';

import 'create_objective_screen.dart';
import 'declare_expense_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';
import 'savings_history_screen.dart';
import 'budget_limit_screen.dart';
import 'taw_expenses_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAlerts();
    });
  }

  void _checkAlerts() {
    final objectives = context.read<ObjectiveProvider>().objectives;
    for (var obj in objectives) {
      if (obj.currentAmount >= obj.targetAmount && obj.targetAmount > 0) {
        NotificationPopup.show(context, "Félicitations ! 🎉", "Objectif '${obj.title}' l'est atteint !");
      } else {
        final daysLeft = obj.targetDate.difference(DateTime.now()).inDays;
        if (daysLeft <= 7 && daysLeft >= 0 && obj.currentAmount < obj.targetAmount) {
          NotificationPopup.show(
            context, 
            "Attention ⚠️", 
            "Objectif '${obj.title}' échoit dans $daysLeft jours, il te manque ${(obj.targetAmount - obj.currentAmount).toStringAsFixed(1)} TND",
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objectiveProvider = context.watch<ObjectiveProvider>();
    final savingsProvider = context.watch<SavingsProvider>();
    final userProvider = context.watch<UserProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();

    double totalSaved = objectiveProvider.objectives.fold(0.0, (sum, o) => sum + o.currentAmount);

    String modeName = "Manuel";
    String extractionText = "Via Dépôts manuels";
    if (savingsProvider.currentMode == SavingsMode.automaticRoundup) {
      modeName = "Automatique (Arrondi)";
      int roundups = expenseProvider.expenses.where((e) => e.roundedSavedAmount > 0).length;
      extractionText = "$roundups extractions via arrondi";
    } else if (savingsProvider.currentMode == SavingsMode.reverseChallenge) {
      modeName = "Défi Inversé";
      extractionText = "Via Défi Inversé";
    }



    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Dashboard Zid", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Synthèse Épargne Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppStyles.borderRadius,
                border: Border.all(color: AppColors.border),
                boxShadow: AppStyles.shadows,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("💰 SYNTHÈSE ÉPARGNE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain)),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildSynthesisRow("Solde TAW actuel", "${userProvider.user?.balance.toStringAsFixed(2)} TND"),
                  _buildSynthesisRow("Total épargné", "${(objectiveProvider.objectives.fold(0.0, (sum, o) => sum + o.currentAmount)).toStringAsFixed(2)} TND"),
                  _buildSynthesisRow("Dépenses du mois", "${expenseProvider.totalExpensesCurrentMonth.toStringAsFixed(2)} TND"),
                  _buildSynthesisRow("Mode actif", modeName, isHighlight: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // 1. Historique Épargne (SavingsHistoryScreen)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingsHistoryScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryValue,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
                elevation: 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Historique des Épargnes : ${totalSaved.toStringAsFixed(2)} TND", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(extractionText, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // 2. Dépenses TAW
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TawExpensesScreen()));
              },
              icon: const Icon(Icons.list_alt, color: Colors.white),
              label: const Text("Dépenses TAW", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Limites Budget par catégorie
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetLimitScreen()));
              },
              icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
              label: const Text("Limites Budget par catégorie", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryValue,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
              ),
            ),
            const SizedBox(height: 24),



            // Objectives Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mes Objectifs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primaryValue),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateObjectiveScreen()));
                  },
                )
              ],
            ),
            const SizedBox(height: 8),
            
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: objectiveProvider.objectives.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("Aucun objectif pour le moment. Appuie sur + pour en créer un !", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    )
                  : _buildDraggableList(objectiveProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableList(ObjectiveProvider provider) {
    return DragAndDropLists(
      children: [
        DragAndDropList(
          children: provider.objectives.asMap().entries.map((entry) {
            int idx = entry.key;
            var obj = entry.value;
            return DragAndDropItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ObjectiveCard(
                  objective: obj,
                  index: idx + 1,
                  onTap: () {
                     // Details logic if needed
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
      onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
        provider.reorderObjectives(oldItemIndex, newItemIndex);
      },
      onListReorder: (int oldListIndex, int newListIndex) {},
      itemDecorationWhileDragging: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
      ),
      listPadding: const EdgeInsets.all(0),
    );
  }

  Widget _buildSynthesisRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isHighlight ? AppColors.primaryValue : AppColors.textMain)),
        ],
      ),
    );
  }
}
