import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CategoryGrid extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> categories = [
    {"name": "Courses", "icon": Icons.shopping_cart_outlined},
    {"name": "Transport", "icon": Icons.directions_bus_outlined},
    {"name": "Loyer", "icon": Icons.home_outlined},
    {"name": "Médical", "icon": Icons.medical_services_outlined},
    {"name": "Loisirs", "icon": Icons.movie_outlined},
    {"name": "Autre", "icon": Icons.more_horiz_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategory == category["name"];
        return GestureDetector(
          onTap: () => onCategorySelected(category["name"]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryValue.withOpacity(0.1) : AppColors.surface,
              borderRadius: AppStyles.borderRadius,
              border: Border.all(
                color: isSelected ? AppColors.primaryValue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category["icon"],
                  color: isSelected ? AppColors.primaryValue : AppColors.textSecondary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  category["name"],
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryValue : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
