import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle light({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle regular({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle medium({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle semiBold({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle bold({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle extraBold({
    double fontSize = 14,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // =========
  // Semantic Styles
  // =========

  static TextStyle displayLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 50,
      fontWeight: FontWeight.w800,
      color: color,
      height: 1.1,
    );
  }

  static TextStyle displayMedium({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.15,
    );
  }

  static TextStyle heading1({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle heading2({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.25,
    );
  }

  static TextStyle heading3({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle titleLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle titleMedium({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.35,
    );
  }

  static TextStyle bodyLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodySmall({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.45,
    );
  }

  static TextStyle labelLarge({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle labelMedium({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle button({
    Color color = Colors.white,
  }) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle caption({
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.35,
    );
  }
}