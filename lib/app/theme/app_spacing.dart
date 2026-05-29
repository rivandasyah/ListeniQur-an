import 'package:flutter/widgets.dart';

/// Central spacing tokens used by layouts and reusable widgets.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const EdgeInsets pagePadding = EdgeInsets.all(md);
  static const EdgeInsets sectionPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets touchPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
