import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.cormorantGaramond(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: AppColors.textPrimary,
    ),
    displayMedium: GoogleFonts.cormorantGaramond(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.15,
      color: AppColors.textPrimary,
    ),
    headlineLarge: GoogleFonts.cormorantGaramond(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: AppColors.textPrimary,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.textPrimary,
    ),
    titleLarge: GoogleFonts.dmSerifText(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      height: 1.25,
      color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textSecondary,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textSecondary,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: AppColors.surface,
    ),
  );
}
