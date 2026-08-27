import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Container padding (design token: spacing-md)
  static const double containerPadding = 24;

  // Radius
  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 18;
  static const double radiusLg = 20;
  static const double radiusXl = 28;

  // Elevation / Shadow
  static const double elevationCard = 4;

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 24,
    ),
  ];
}
