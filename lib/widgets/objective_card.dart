import 'package:flutter/material.dart';
import '../models/objective.dart';
import '../utils/constants.dart';
import 'progress_bar.dart';
import 'package:intl/intl.dart';

class ObjectiveCard extends StatelessWidget {
  final Objective objective;
  final VoidCallback onTap;
  final int index;

  const ObjectiveCard({
    super.key,
    required this.objective,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = objective.currentAmount >= objective.targetAmount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppStyles.borderRadius,
          border: isCompleted
              ? Border.all(color: AppColors.primaryValue, width: 2)
              : null,
          boxShadow: AppStyles.shadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.emoji_events : Icons.flag_outlined,
                      color: isCompleted ? AppColors.primaryValue : AppColors.textMain,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      objective.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.drag_indicator, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedProgressBar(
              current: objective.currentAmount,
              total: objective.targetAmount,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Échéance: ${DateFormat('dd/MM/yyyy').format(objective.targetDate)}",
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Text(
                  "Ordre: $index",
                  style: const TextStyle(fontSize: 12, color: AppColors.primaryValue, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
