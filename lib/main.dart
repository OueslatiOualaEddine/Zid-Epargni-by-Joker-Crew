import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/storage_service.dart';
import 'providers/user_provider.dart';
import 'providers/objective_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/savings_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive local storage
  await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ObjectiveProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => SavingsProvider()),
      ],
      child: const ZidApp(),
    ),
  );
}

class ZidApp extends StatelessWidget {
  const ZidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zid (TAW)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
