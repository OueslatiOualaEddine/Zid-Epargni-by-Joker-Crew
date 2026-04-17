import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double current;
  final double total;
  final Color filledColor;

  const AnimatedProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.filledColor = AppColors.primaryValue,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? (current / total) : 0;
    if (progress > 1.0) progress = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${current.toStringAsFixed(1)} TND",
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
            Text("${total.toStringAsFixed(1)} TND",
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              height: 10,
              width: MediaQuery.of(context).size.width * progress, // Simplified width calculation
              decoration: BoxDecoration(
                color: filledColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
