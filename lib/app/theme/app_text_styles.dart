import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Central typography tokens based on scalable font sizes.
class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'SFUIText';

  static TextStyle size(double fontSize, FontWeight weight) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: weight,
      letterSpacing: 0,
    );
  }

  static WeightStyle get light => WeightStyle(FontWeight.w300);
  static WeightStyle get regular => WeightStyle(FontWeight.w400);
  static WeightStyle get medium => WeightStyle(FontWeight.w500);
  static WeightStyle get semibold => WeightStyle(FontWeight.w600);
  static WeightStyle get bold => WeightStyle(FontWeight.w700);
  static WeightStyle get ultraBold => WeightStyle(FontWeight.w900);

  static TextStyle get headlineLarge =>
      bold.s32.copyWith(height: 1.16, color: AppColors.primaryText);

  static TextStyle get headlineMedium =>
      bold.s24.copyWith(height: 1.2, color: AppColors.primaryText);

  static TextStyle get titleLarge =>
      semibold.s20.copyWith(height: 1.25, color: AppColors.primaryText);

  static TextStyle get bodyLarge =>
      medium.s16.copyWith(height: 1.45, color: AppColors.primaryText);

  static TextStyle get bodyMedium =>
      medium.s14.copyWith(height: 1.45, color: AppColors.secondaryText);

  static TextStyle get caption =>
      medium.s12.copyWith(height: 1.35, color: AppColors.secondaryText);

  static TextTheme get textTheme => TextTheme(
    displayLarge: headlineLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    labelLarge: bodyMedium.copyWith(
      color: AppColors.background,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: caption,
    bodySmall: caption,
  );
}

/// Fluent helper for weight-first text styles, e.g. `AppTextStyles.bold.s16`.
class WeightStyle {
  final FontWeight weight;

  const WeightStyle(this.weight);

  TextStyle get s10 => AppTextStyles.size(10, weight);
  TextStyle get s12 => AppTextStyles.size(12, weight);
  TextStyle get s14 => AppTextStyles.size(14, weight);
  TextStyle get s16 => AppTextStyles.size(16, weight);
  TextStyle get s18 => AppTextStyles.size(18, weight);
  TextStyle get s20 => AppTextStyles.size(20, weight);
  TextStyle get s22 => AppTextStyles.size(22, weight);
  TextStyle get s24 => AppTextStyles.size(24, weight);
  TextStyle get s32 => AppTextStyles.size(32, weight);
}
