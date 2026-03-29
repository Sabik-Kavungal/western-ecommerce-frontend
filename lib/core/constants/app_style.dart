import 'package:flutter/material.dart';

import 'app_color.dart';

/// Central text styles. Use [AppStyle] for consistent typography.
class AppStyle {
  AppStyle._();

  static const String _fontFamily = 'Poppins';

  // ----- Display -----
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  // ----- Titles -----
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ----- Body -----
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.text,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.text,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // ----- Labels -----
  static const TextStyle labelButton = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle labelLink = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.redAccent,
  );
  static const TextStyle labelError = TextStyle(
    fontSize: 14,
    color: AppColors.redAccent,
  );
  static const TextStyle labelCaption = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // ----- AppBar -----
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
}
