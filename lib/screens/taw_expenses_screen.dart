import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import 'declare_expense_screen.dart';

class TawExpensesScreen extends StatefulWidget {
  const TawExpensesScreen({super.key});

  @override
  State<TawExpensesScreen> createState() => _TawExpensesScreenState();
}

class _TawExpensesScreenState extends State<TawExpensesScreen> {
  String _selectedMonth = "Tous";

  @override
  Widget build(BuildContext context) {
    var ep = context.watch<ExpenseProvider>();
    
    // Extract unique months for the dropdown
    Set<String> months = {};
    for (var e in ep.expenses) {
      months.add(DateFormat('MM/yyyy').format(e.date));
    }
    months.add(DateFormat('MM/yyyy').format(DateTime.now())); // Ensure current month exists
    
    List<String> monthList = ["Tous"];
    List<String> sortedMonths = months.toList()..sort((a,b) => b.compareTo(a));
    monthList.addAll(sortedMonths);

    if (!monthList.contains(_selectedMonth)) {
      _selectedMonth = "Tous";
    }

    var filtered = _selectedMonth == "Tous" 
      ? ep.expenses 
      : ep.expenses.where((e) => DateFormat('MM/yyyy').format(e.date) == _selectedMonth).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Dépenses TAW", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filtrer par mois :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain)),
                DropdownButton<String>(
                  value: _selectedMonth,
                  items: monthList.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMonth = val);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("Aucune dépense ce mois-ci."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final e = filtered[index];
                      return Card(
                        color: AppColors.surface,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.payment, color: AppColors.textSecondary)),
                          title: Text(e.category, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                          subtitle: Text(DateFormat('dd/MM HH:mm').format(e.date), style: const TextStyle(color: AppColors.textSecondary)),
                          trailing: Text("-${e.amount.toStringAsFixed(2)} TND", style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      // Adding a small discrete + button so you can still add test expenses for the MVP demo
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryValue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DeclareExpenseScreen()));
        },
      ),
    );
  }
}
