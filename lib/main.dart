import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/welcome/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SehatBersamaApp());
}

class SehatBersamaApp extends StatelessWidget {
  const SehatBersamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sehat Bersama Smart Village',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
