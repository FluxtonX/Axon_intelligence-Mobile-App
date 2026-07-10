import 'package:flutter/material.dart';

/// Axon Intelligence — App Color System
/// Based on Figma design tokens — colors added screen-by-screen.
abstract class AppColors {
  AppColors._();

  // ─── Gradient Colors (Splash Screen) ──────────────────────────────────────
  static const Color gradientStart = Color(0xFF284AA3);
  static const Color gradientMid   = Color(0xFF1D2C58);
  static const Color gradientEnd   = Color(0xFF1A3681);

  // ─── Core Backgrounds ─────────────────────────────────────────────────────
  /// Dark background — main app screens
  static const Color background = Color(0xFF0F1117);

  /// Light background — onboarding & auth screens
  static const Color backgroundLight = Color(0xFFFFFFFF);

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textDark      = Color(0xFF0F1117);  // for light screens
  static const Color textSecondary = Color(0xFF6B7280);

  // ─── Brand / Accent ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3B6EF5);
  static const Color surface = Color(0xFFF3F4F6);

  // ─── Onboarding Slide 1 — Blue ────────────────────────────────────────────
  static const Color ob1Accent  = Color(0xFF3B6EF5);
  static const Color ob1IconBg  = Color(0xFFEEF2FF);
  static const Color ob1StatBg  = Color(0xFFE0E9FF);  // Figma: #E0E9FF

  // ─── Onboarding Slide 2 — Green ───────────────────────────────────────────
  static const Color ob2Accent  = Color(0xFF10B981);
  static const Color ob2IconBg  = Color(0xFFECFDF5);
  static const Color ob2StatBg  = Color(0xFFECFDF5);  // Figma: #ECFDF5

  // ─── Onboarding Slide 3 — Purple ──────────────────────────────────────────
  static const Color ob3Accent  = Color(0xFF8B5CF6);
  static const Color ob3IconBg  = Color(0xFFF5F3FF);
  static const Color ob3StatBg  = Color(0xFFEDE9FE);  // Figma: slightly purple

  // ─── Splash Gradient Helper ───────────────────────────────────────────────
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [gradientStart, gradientMid, gradientEnd],
  );
}
