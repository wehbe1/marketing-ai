import 'package:flutter/material.dart';
import 'colors.dart';

class AppText {
  static const h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );
}
