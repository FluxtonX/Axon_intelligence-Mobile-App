import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_constants.dart';

enum AppButtonVariant { primary, secondary, outlined, ghost }

/// Axon Intelligence — Reusable App Button
/// Use this for all CTA buttons throughout the app.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = 52,
    this.borderRadius = AppConstants.radiusMD,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
          borderRadius: borderRadius,
        );
      case AppButtonVariant.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
          borderRadius: borderRadius,
        );
      case AppButtonVariant.outlined:
        return _OutlinedButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
          borderRadius: borderRadius,
        );
      case AppButtonVariant.ghost:
        return _GhostButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          icon: icon,
        );
    }
  }
}

// ─── Primary Button ─────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    required this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textStyle: AppTypography.buttonLarge,
      ),
    );
  }
}

// ─── Secondary Button ────────────────────────────────────────────────────────
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    required this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E2235),
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: Color(0xFF2D3142), width: 1),
        ),
        elevation: 0,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textStyle: AppTypography.buttonLarge,
      ),
    );
  }
}

// ─── Outlined Button ─────────────────────────────────────────────────────────
class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    required this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textStyle: AppTypography.buttonLarge.copyWith(color: AppColors.primary),
      ),
    );
  }
}

// ─── Ghost / Text Button ─────────────────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        icon: icon,
        textStyle: AppTypography.buttonMedium.copyWith(color: AppColors.primary),
      ),
    );
  }
}

// ─── Shared Content Widget ───────────────────────────────────────────────────
class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.textStyle,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final IconData? icon;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconMD),
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    }

    return Text(label, style: textStyle);
  }
}
