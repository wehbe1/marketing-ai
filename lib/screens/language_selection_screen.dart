import 'package:flutter/material.dart';
import '../localization/app_language.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final ValueChanged<AppLanguage> onLanguageSelected;

  const LanguageSelectionScreen({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'בחר שפה / Choose language',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildLangButton(
                label: 'עברית',
                onTap: () => onLanguageSelected(AppLanguage.he),
              ),
              const SizedBox(height: 12),
              _buildLangButton(
                label: 'English',
                onTap: () => onLanguageSelected(AppLanguage.en),
              ),
              const SizedBox(height: 12),
              _buildLangButton(
                label: 'العربية',
                onTap: () => onLanguageSelected(AppLanguage.ar),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 220,
      child: ElevatedButton(onPressed: onTap, child: Text(label)),
    );
  }
}
