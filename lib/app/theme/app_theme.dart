import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    return _buildTheme(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.surface,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      surfaceColor: AppColors.surface,
      surfaceSoftColor: AppColors.surfaceSoft,
      borderColor: AppColors.border,
      foregroundColor: AppColors.textPrimary,
      secondaryTextColor: AppColors.textSecondary,
    );
  }

  static ThemeData get dark {
    return _buildTheme(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFD7A06E),
        onPrimary: Color(0xFF231A15),
        secondary: Color(0xFFE1B486),
        onSecondary: Color(0xFF231A15),
        error: Color(0xFFE28B8B),
        onError: Color(0xFF231A15),
        surface: Color(0xFF221A16),
        onSurface: Color(0xFFF8EEE5),
      ),
      scaffoldBackgroundColor: const Color(0xFF18120F),
      surfaceColor: const Color(0xFF221A16),
      surfaceSoftColor: const Color(0xFF2E241E),
      borderColor: const Color(0xFF4D3A31),
      foregroundColor: const Color(0xFFF8EEE5),
      secondaryTextColor: const Color(0xFFD1C0B2),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color surfaceSoftColor,
    required Color borderColor,
    required Color foregroundColor,
    required Color secondaryTextColor,
  }) {
    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: foregroundColor,
      displayColor: foregroundColor,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: textTheme,
      fontFamily: AppTextStyles.textTheme.bodyLarge?.fontFamily,
    );

    final shapeMd = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    final shapeLg = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: shapeLg,
        shadowColor: AppColors.shadow,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: AppSpacing.buttonPadding,
          elevation: 0,
          shape: shapeMd,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: AppSpacing.buttonPadding,
          side: BorderSide(color: borderColor),
          shape: shapeMd,
          textStyle: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.4,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceSoftColor,
        selectedColor: colorScheme.primary,
        disabledColor: borderColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: foregroundColor,
        ),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return secondaryTextColor;
        }),
      ),
      dividerColor: borderColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: foregroundColor,
        textColor: foregroundColor,
      ),
    );
  }
}
