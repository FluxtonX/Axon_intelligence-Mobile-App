import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Axon Intelligence — Primary Action Button
///
/// Used for main CTAs across the app: onboarding, auth, forms, etc.
/// Supports animated label switching (e.g., "Continue" → "Get Started").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.arrow_forward_rounded,
    this.showIcon = true,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 28,
    this.fontSize = 16,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool showIcon;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated label so switching text fades smoothly
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      label,
                      key: ValueKey(label),
                      style: AppTypography.buttonLarge.copyWith(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (showIcon) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: Colors.white, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
