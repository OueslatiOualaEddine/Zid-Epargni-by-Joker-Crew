import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryValue = Color(0xFFE71F77); // Pink
  static const Color secondaryValue = Color(0xFF36B0C8); // Teal
  static const Color background = Color(0xFFEDF2F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color alert = Color(0xFFE71F77);
  static const Color warning = Color(0xFF36B0C8);
  static const Color border = Color(0xFFEEEEEE);

  static const MaterialColor primary = MaterialColor(
    0xFF00A859,
    <int, Color>{
      50: Color(0xFFE0F4EA),
      100: Color(0xFFB3E4CB),
      200: Color(0xFF80D3A9),
      300: Color(0xFF4DC187),
      400: Color(0xFF26B36E),
      500: primaryValue,
      600: Color(0xFF009F51),
      700: Color(0xFF009447),
      800: Color(0xFF00893E),
      900: Color(0xFF00772E),
    },
  );
}

class AppStyles {
  // Border radius as per TAW guidelines
  static final BorderRadius borderRadius = BorderRadius.circular(12.0);
  
  // Shadows
  static final List<BoxShadow> shadows = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 2),
      blurRadius: 4,
    )
  ];
}
