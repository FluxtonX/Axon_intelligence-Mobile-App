/// App-wide constants — routes, keys, durations, etc.
abstract class AppConstants {
  AppConstants._();

  // ─── App Info ─────────────────────────────────────────────────────────────
  static const String appName = 'Axon Intelligence';
  static const String appVersion = '1.0.0';

  // ─── Splash ───────────────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(seconds: 3);

  // ─── Animation Durations ──────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ─── Spacing ──────────────────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ─── Border Radius ────────────────────────────────────────────────────────
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 100.0;

  // ─── Icon Sizes ───────────────────────────────────────────────────────────
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 32.0;
}
