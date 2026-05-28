import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF5B6EFF);
  static const primaryDark = Color(0xFF9B5BFF);
  static const primaryLight = Color(0xFFEEF0FF);

  // Backgrounds
  static const background = Color(0xFFF7F8FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F3FF);

  // Hero / dark sections
  static const heroBg = Color(0xFF0F0F23);
  static const heroBgEnd = Color(0xFF1E1B4B);

  // Text
  static const textDark = Color(0xFF1A1A2E);
  static const textMedium = Color(0xFF4B5563);
  static const textLight = Color(0xFF9CA3AF);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textOnDarkMuted = Color(0xFFBBBCDD);

  // Feedback
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFD1FAE5);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const warning = Color(0xFFF59E0B);

  // Borders & shadows
  static const border = Color(0xFFE5E7EB);
  static const borderFocus = primary;
  static const shadow = Color(0x185B6EFF);

  // Gradients
  static const gradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientVertical = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const heroGradient = LinearGradient(
    colors: [heroBg, heroBgEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
