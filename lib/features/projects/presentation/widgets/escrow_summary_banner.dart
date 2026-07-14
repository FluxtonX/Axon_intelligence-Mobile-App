import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class EscrowSummaryBanner extends StatelessWidget {
  const EscrowSummaryBanner({
    super.key,
    required this.totalAmount,
  });

  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Total in Escrow',
                style: AppTypography.labelLarge.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: AppTypography.headingLarge.copyWith(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Funds are securely held and ready for release upon milestone approval.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}
