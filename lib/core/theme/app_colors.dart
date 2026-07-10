import 'package:flutter/material.dart';

/// Axon Intelligence — App Color System
/// Based on Figma design tokens (Splash + Core palette)
/// Colors are added screen-by-screen as the app grows.
abstract class AppColors {
  AppColors._();

  // ─── Gradient Colors (Splash Screen) ──────────────────────────────────────
  /// Gradient stop 0% — top of splash gradient
  static const Color gradientStart = Color(0xFF284AA3);

  /// Gradient stop 50% — middle of splash gradient
  static const Color gradientMid = Color(0xFF1D2C58);

  /// Gradient stop 100% — bottom of splash gradient
  static const Color gradientEnd = Color(0xFF1A3681);

  // ─── Core Background ──────────────────────────────────────────────────────
  /// Primary dark background — used for all screens
  static const Color background = Color(0xFF0F1117);

  // ─── Text Colors ──────────────────────────────────────────────────────────
  /// Primary text — white
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary/muted text — subheadings, hints, placeholders
  static const Color textSecondary = Color(0xFF6B7280);

  // ─── Brand / Accent ───────────────────────────────────────────────────────
  /// Primary accent blue — buttons, links, highlights
  static const Color primary = Color(0xFF3B6EF5);

  // ─── Splash Gradient Helper ───────────────────────────────────────────────
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [gradientStart, gradientMid, gradientEnd],
  );
}
