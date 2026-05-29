import 'package:flutter/widgets.dart';

/// Central radius tokens for consistent rounded shapes.
class AppRadius {
  const AppRadius._();

  static const double small = 12;
  static const double medium = 16;
  static const double large = 24;

  static const Radius smallRadius = Radius.circular(small);
  static const Radius mediumRadius = Radius.circular(medium);
  static const Radius largeRadius = Radius.circular(large);

  static const BorderRadius smallBorder = BorderRadius.all(smallRadius);
  static const BorderRadius mediumBorder = BorderRadius.all(mediumRadius);
  static const BorderRadius largeBorder = BorderRadius.all(largeRadius);
}
