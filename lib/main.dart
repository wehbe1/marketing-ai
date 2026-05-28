import 'package:flutter/material.dart';
import 'screens/marketing_plan_screen.dart';
import 'screens/language_selection_screen.dart';
import 'localization/app_language.dart';

void main() {
  runApp(const MarketingAIApp());
}

class MarketingAIApp extends StatefulWidget {
  const MarketingAIApp({super.key});

  @override
  State<MarketingAIApp> createState() => _MarketingAIAppState();
}

class _MarketingAIAppState extends State<MarketingAIApp> {
  AppLanguage? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3366FF),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marketing AI',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home:
          _selectedLanguage == null
              ? LanguageSelectionScreen(
                onLanguageSelected: (lang) {
                  setState(() {
                    _selectedLanguage = lang;
                  });
                },
              )
              : MarketingPlanScreen(language: _selectedLanguage!),
    );
  }
}
