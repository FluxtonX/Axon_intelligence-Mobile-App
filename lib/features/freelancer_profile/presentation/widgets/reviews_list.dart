import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: AppTypography.headingMedium.copyWith(
                color: const Color(0xFF111827),
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 4),
                Text(
                  '4.98',
                  style: AppTypography.labelLarge.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (87)',
                  style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        _buildReviewItem(
          'TechNova Inc.',
          'Amazing work on our mobile app redesign. Sophia was incredibly professional, delivered ahead of schedule, and the final designs were pixel-perfect.',
          '1 week ago',
          5.0,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: Color(0xFFE5E7EB)),
        ),
        _buildReviewItem(
          'Alexander Wright',
          'A true expert in Figma and UX. She helped us untangle a very complex user flow and made it feel effortless. Will definitely hire again.',
          '1 month ago',
          5.0,
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Show all 87 reviews'),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String clientName, String reviewText, String timeAgo, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF3F4F6),
              child: Text(
                clientName[0],
                style: AppTypography.labelMedium.copyWith(color: const Color(0xFF4B5563)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                clientName,
                style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827)),
              ),
            ),
            Text(
              timeAgo,
              style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            5,
            (index) => const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          reviewText,
          style: AppTypography.bodyMedium.copyWith(
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
