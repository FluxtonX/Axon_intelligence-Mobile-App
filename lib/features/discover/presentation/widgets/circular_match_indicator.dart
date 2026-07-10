import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class CircularMatchIndicator extends StatelessWidget {
  final int matchPercentage;

  const CircularMatchIndicator({
    super.key,
    required this.matchPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on percentage
    Color indicatorColor;
    if (matchPercentage >= 90) {
      indicatorColor = const Color(0xFF10B981); // Emerald Green
    } else if (matchPercentage >= 70) {
      indicatorColor = const Color(0xFFF59E0B); // Amber/Yellow
    } else {
      indicatorColor = const Color(0xFFEF4444); // Red
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                value: matchPercentage / 100,
                strokeWidth: 3.5,
                color: indicatorColor,
                backgroundColor: indicatorColor.withValues(alpha: 0.15),
              ),
            ),
            Text(
              '$matchPercentage%',
              style: AppTypography.labelLarge.copyWith(
                color: indicatorColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Match',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
