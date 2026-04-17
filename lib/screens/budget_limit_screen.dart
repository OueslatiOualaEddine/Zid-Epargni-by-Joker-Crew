import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/storage_service.dart';
import '../utils/constants.dart';

class BudgetLimitScreen extends StatefulWidget {
  const BudgetLimitScreen({super.key});

  @override
  State<BudgetLimitScreen> createState() => _BudgetLimitScreenState();
}

class _BudgetLimitScreenState extends State<BudgetLimitScreen> {
  late Box<double> budgetBox;
  bool _isAutreExpanded = false;
  final TextEditingController _customCatNameController = TextEditingController();
  final TextEditingController _customCatAmountController = TextEditingController();

  final List<String> defaultCats = ["Courses", "Transport", "Loyer", "Médical", "Loisirs"];

  @override
  void initState() {
    super.initState();
    budgetBox = StorageService.budgetsBox;
  }

  List<String> get _allCategories {
    Set<String> all = Set.from(defaultCats);
    for (var key in budgetBox.keys) {
      if (key is String) all.add(key);
    }
    return all.toList();
  }

  IconData _getIconFor(String cat) {
    if (cat == "Courses") return Icons.shopping_cart_outlined;
    if (cat == "Transport") return Icons.directions_bus_outlined;
    if (cat == "Loyer") return Icons.home_outlined;
    if (cat == "Médical") return Icons.medical_services_outlined;
    if (cat == "Loisirs") return Icons.movie_outlined;
    return Icons.category_outlined;
  }

  void _saveLimit(String category, String value) {
    if (value.trim().isEmpty) {
      budgetBox.delete(category);
      setState((){});
      return;
    }
    double? limit = double.tryParse(value);
    if (limit != null && limit >= 0) {
      budgetBox.put(category, limit);
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayCategories = _allCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Limites de Budget", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.secondaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryValue.withOpacity(0.1),
                borderRadius: AppStyles.borderRadius,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primaryValue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Définissez un plafond mensuel par catégorie. Zid vous alertera avec un conseil IA si vous le dépassez.",
                      style: TextStyle(color: AppColors.textMain, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayCategories.length + 1,
              itemBuilder: (context, index) {
                if (index == displayCategories.length) {
                  return _buildAutreDropdown(context);
                }
                
                String catName = displayCategories[index];
                double? currentLimit = budgetBox.get(catName);
                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondaryValue.withOpacity(0.1),
                      child: Icon(_getIconFor(catName), color: AppColors.secondaryValue),
                    ),
                    title: Text(catName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: SizedBox(
                      width: 120,
                      child: TextField(
                        controller: TextEditingController(text: currentLimit?.toStringAsFixed(0) ?? ""),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Pas de limite",
                          suffixText: "TND",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryValue, width: 2)),
                        ),
                        onSubmitted: (val) {
                          _saveLimit(catName, val);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Limite enregistrée.")));
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutreDropdown(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.secondaryValue.withOpacity(0.1),
              child: const Icon(Icons.more_horiz_outlined, color: AppColors.secondaryValue),
            ),
            title: const Text("Autre catégorie spéciale", style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              setState(() {
                _isAutreExpanded = !_isAutreExpanded;
              });
            },
            trailing: Icon(_isAutreExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          ),
          if (_isAutreExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _customCatNameController,
                      decoration: const InputDecoration(
                        labelText: "Nom de la dépense",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _customCatAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "TND",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primaryValue, size: 36),
                    onPressed: () {
                      if (_customCatNameController.text.isNotEmpty && _customCatAmountController.text.isNotEmpty) {
                        _saveLimit(_customCatNameController.text.trim(), _customCatAmountController.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Limite pour '${_customCatNameController.text}' enregistrée.")));
                        
                        // Close and reset
                        setState(() {
                           _isAutreExpanded = false;
                           _customCatNameController.clear();
                           _customCatAmountController.clear();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
