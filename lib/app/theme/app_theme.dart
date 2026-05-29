import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Shared subtle shadow tokens.
class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: AppSpacing.md,
      offset: Offset(0, AppSpacing.xs),
    ),
  ];
}

/// App-wide Material theme built from design tokens.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      surface: AppColors.background,
      onSurface: AppColors.primaryText,
      secondary: AppColors.islamicAccent,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryBlue,
      textTheme: AppTextStyles.textTheme,
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        titleTextStyle: AppTextStyles.titleLarge,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceElevated,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mediumBorder,
          side: BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(kMinInteractiveDimensionCupertino),
          padding: AppSpacing.touchPadding,
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.background,
          textStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.background,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.mediumBorder,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(kMinInteractiveDimensionCupertino),
          padding: AppSpacing.touchPadding,
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.mediumBorder,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            kMinInteractiveDimensionCupertino,
            kMinInteractiveDimensionCupertino,
          ),
          padding: AppSpacing.touchPadding,
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeBorder),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryBackground,
        contentPadding: AppSpacing.touchPadding,
        hintStyle: AppTextStyles.bodyMedium,
        labelStyle: AppTextStyles.bodyMedium,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mediumBorder,
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: AppSpacing.lg,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.cardPadding,
        iconColor: AppColors.primaryBlue,
        titleTextStyle: AppTextStyles.bodyLarge,
        subtitleTextStyle: AppTextStyles.bodyMedium,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mediumBorder,
        ),
      ),
      splashColor: AppColors.pressedOverlay,
      highlightColor: AppColors.pressedOverlay,
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.background,
      ),
    );
  }
}
