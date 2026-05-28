import 'package:flutter/material.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';

class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.he;

  AppLanguage get language => _language;

  /// True for Hebrew and Arabic — drives [Directionality] in the widget tree.
  bool get isRtl => _language == AppLanguage.he || _language == AppLanguage.ar;

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  AppStrings get s => AppStrings(_language);

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

  void toggle() {
    setLanguage(_language == AppLanguage.he ? AppLanguage.en : AppLanguage.he);
  }
}
