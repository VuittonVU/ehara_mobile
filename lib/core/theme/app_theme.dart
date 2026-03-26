import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textPrimary),
    ),
  );
}