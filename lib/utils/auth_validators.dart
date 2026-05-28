import '../localization/strings.dart';

abstract final class AuthValidators {
  static final _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _passwordPattern = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d).{8,}$',
  );

  static String? validateEmail(String? value, AppStrings s) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return s.errorEmailRequired;
    if (!_emailPattern.hasMatch(email)) return s.errorEmailInvalid;
    return null;
  }

  static String? validatePassword(String? value, AppStrings s) {
    if (value == null || value.isEmpty) return s.errorPasswordRequired;
    if (value.length < 8) return s.errorPasswordShort;
    if (!_passwordPattern.hasMatch(value)) return s.errorPasswordWeak;
    return null;
  }

  static String? validateLoginPassword(String? value, AppStrings s) {
    if (value == null || value.isEmpty) return s.errorPasswordRequired;
    return null;
  }
}
