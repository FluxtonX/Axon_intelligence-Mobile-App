import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class MilestoneActionCard extends StatelessWidget {
  const MilestoneActionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    this.isActionable = false,
    this.onActionPressed,
  });

  final String title;
  final double amount;
  final String status;
  final bool isActionable;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF10B981), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Milestone Submitted',
                      style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827)),
                    ),
                  ],
                ),
                Text(
                  '\$$amount',
                  style: AppTypography.headingSmall.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
            ),
            const SizedBox(height: 20),
            if (isActionable)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        'Request Changes',
                        style: AppTypography.buttonMedium.copyWith(color: const Color(0xFF374151)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onActionPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Approve & Pay',
                        style: AppTypography.buttonMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: AppTypography.labelMedium.copyWith(color: const Color(0xFF374151)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
