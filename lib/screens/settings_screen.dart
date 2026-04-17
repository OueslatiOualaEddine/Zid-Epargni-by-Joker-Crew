import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/savings_provider.dart';
import '../providers/user_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/objective_provider.dart';
import '../services/storage_service.dart';
import '../services/savings_logic.dart';
import '../models/savings_mode.dart';
import '../utils/constants.dart';
import '../widgets/notification_popup.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savingsProvider = context.watch<SavingsProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text("Paramètres Zid", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Mode d'épargne principal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textMain)),
          const SizedBox(height: 16),
          _buildModeOption(
            context,
            "Manuel",
            "Tu ajoutes de l'argent quand tu le souhaites.",
            SavingsMode.manual,
            savingsProvider,
          ),
          _buildModeOption(
            context,
            "Automatique (Arrondi)",
            "Chaque dépense est arrondie au TND supérieur. La différence est épargnée.",
            SavingsMode.automaticRoundup,
            savingsProvider,
          ),
          _buildModeOption(
            context,
            "Défi Inversé",
            "Épargne dès le début du mois un montant fixe.",
            SavingsMode.reverseChallenge,
            savingsProvider,
          ),
          const SizedBox(height: 32),
          const Text("Mon Profil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textMain)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
            title: const Text("Solde Actuel"),
            subtitle: Text("${userProvider.user?.balance.toStringAsFixed(2)} TND"),
            trailing: const Icon(Icons.edit, color: AppColors.primaryValue),
            onTap: () {
               _showEditBalanceDialog(context, userProvider);
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
               // Reset Logic
               await StorageService.clearAll();
               // Reload app state roughly
               NotificationPopup.show(context, "Données effacées", "Re-démarre l'application pour reprendre à zéro.");
            },
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            label: const Text("Réinitialiser les données", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModeOption(BuildContext context, String title, String subtitle, SavingsMode mode, SavingsProvider provider) {
    bool isSelected = mode == provider.currentMode;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadius,
        border: Border.all(color: isSelected ? AppColors.primaryValue : Colors.transparent, width: 2),
      ),
      child: RadioListTile<SavingsMode>(
        value: mode,
        groupValue: provider.currentMode,
        onChanged: (SavingsMode? newMode) {
          if (newMode != null) {
            if (newMode == SavingsMode.reverseChallenge) {
               _showReverseChallengeDialog(context, provider);
            } else {
               provider.setMode(newMode);
               NotificationPopup.show(context, "Mode changé", "Ton mode d'épargne est maintenant : $title");
            }
          }
        },
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        activeColor: AppColors.primaryValue,
      ),
    );
  }

  void _showEditBalanceDialog(BuildContext context, UserProvider provider) {
    final TextEditingController ctrl = TextEditingController(text: provider.user?.balance.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Modifier le solde"),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: "Nouveau solde"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                 double? val = double.tryParse(ctrl.text);
                 if (val != null) {
                   provider.updateBalance(val);
                   Navigator.pop(ctx);
                 }
              }
            },
            child: const Text("Sauvegarder"),
          )
        ],
      ),
    );
  }

  Future<void> _showReverseChallengeDialog(BuildContext context, SavingsProvider provider) async {
    final TextEditingController amountCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Activer le défi inversé"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quel montant veux-tu épargner immédiatement sur ton solde ce mois-ci ?"),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Montant (TND)", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryValue),
            onPressed: () {
              if (amountCtrl.text.isNotEmpty) {
                 double? val = double.tryParse(amountCtrl.text);
                 if (val != null && val > 0) {
                   final logic = SavingsLogic(
                     objectiveProvider: ctx.read<ObjectiveProvider>(),
                     userProvider: ctx.read<UserProvider>(),
                     expenseProvider: ctx.read<ExpenseProvider>(),
                   );
                   logic.processReverseChallenge(val);
                   provider.setMode(SavingsMode.reverseChallenge);
                   NotificationPopup.show(context, "Défi Inversé Activé 🎉", "$val TND sécurisés et injectés dans tes objectifs !");
                   Navigator.pop(ctx);
                 }
              }
            },
            child: const Text("Valider et Épargner"),
          )
        ],
      ),
    );
  }
}
