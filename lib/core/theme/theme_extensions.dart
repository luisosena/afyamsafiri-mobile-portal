import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.confirmed,
    required this.urgent,
    required this.pending,
    required this.draft,
    required this.cancelled,
    required this.defaultInteractive,
  });

  final Color confirmed;
  final Color urgent;
  final Color pending;
  final Color draft;
  final Color cancelled;
  final Color defaultInteractive;

  @override
  AppSemanticColors copyWith({
    Color? confirmed,
    Color? urgent,
    Color? pending,
    Color? draft,
    Color? cancelled,
    Color? defaultInteractive,
  }) {
    return AppSemanticColors(
      confirmed: confirmed ?? this.confirmed,
      urgent: urgent ?? this.urgent,
      pending: pending ?? this.pending,
      draft: draft ?? this.draft,
      cancelled: cancelled ?? this.cancelled,
      defaultInteractive: defaultInteractive ?? this.defaultInteractive,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      confirmed: Color.lerp(confirmed, other.confirmed, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      draft: Color.lerp(draft, other.draft, t)!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
      defaultInteractive: Color.lerp(defaultInteractive, other.defaultInteractive, t)!,
    );
  }
}
