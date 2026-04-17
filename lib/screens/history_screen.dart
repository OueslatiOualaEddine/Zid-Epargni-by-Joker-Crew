import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text("Historique Zid", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: expenses.isEmpty
          ? const Center(child: Text("Aucune dépense pour le moment."))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppStyles.borderRadius,
                    boxShadow: AppStyles.shadows,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.category,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(expense.date),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          if (expense.roundedSavedAmount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "+ ${expense.roundedSavedAmount.toStringAsFixed(2)} TND épargnés",
                                style: const TextStyle(color: AppColors.primaryValue, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                        ],
                      ),
                      Text(
                        "-${expense.amount.toStringAsFixed(2)} TND",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.alert, fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
