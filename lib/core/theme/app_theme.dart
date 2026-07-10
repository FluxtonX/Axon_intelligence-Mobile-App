import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Axon Intelligence — Global App Theme
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // ─── Colors ────────────────────────────────────────────────────
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.textPrimary,
          secondary: AppColors.gradientStart,
          onSecondary: AppColors.textPrimary,
          surface: AppColors.background,
          onSurface: AppColors.textPrimary,
          error: Color(0xFFEF4444),
          onError: AppColors.textPrimary,
        ),

        // ─── Typography ────────────────────────────────────────────────
        textTheme: GoogleFonts.interTextTheme(
          const TextTheme(
            displayLarge: TextStyle(color: AppColors.textPrimary),
            displayMedium: TextStyle(color: AppColors.textPrimary),
            displaySmall: TextStyle(color: AppColors.textPrimary),
            headlineLarge: TextStyle(color: AppColors.textPrimary),
            headlineMedium: TextStyle(color: AppColors.textPrimary),
            headlineSmall: TextStyle(color: AppColors.textPrimary),
            titleLarge: TextStyle(color: AppColors.textPrimary),
            titleMedium: TextStyle(color: AppColors.textPrimary),
            titleSmall: TextStyle(color: AppColors.textPrimary),
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textPrimary),
            bodySmall: TextStyle(color: AppColors.textSecondary),
            labelLarge: TextStyle(color: AppColors.textPrimary),
            labelMedium: TextStyle(color: AppColors.textSecondary),
            labelSmall: TextStyle(color: AppColors.textSecondary),
          ),
        ),

        // ─── AppBar ────────────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          titleTextStyle: AppTypography.headingSmall,
        ),

        // ─── Elevated Button ───────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.buttonLarge,
            elevation: 0,
          ),
        ),

        // ─── Text Button ───────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.buttonMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // ─── Outlined Button ───────────────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTypography.buttonLarge,
          ),
        ),

        // ─── Input Decoration ──────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1D27),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D3142), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),

        // ─── Card ──────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1D27),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2D3142), width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        // ─── Bottom Nav Bar ────────────────────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF141720),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),

        // ─── Divider ───────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2D3142),
          thickness: 1,
          space: 0,
        ),
      );
}
