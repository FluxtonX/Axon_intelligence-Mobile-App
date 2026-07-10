import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class InterviewCard extends StatelessWidget {
  const InterviewCard({
    super.key,
    required this.name,
    required this.time,
    required this.status,
    required this.imageUrl,
  });

  final String name;
  final String time;
  final String status; // 'confirmed' or 'pending'
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final bool isConfirmed = status.toLowerCase() == 'confirmed';
    final Color statusColor = isConfirmed ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    final Color statusBgColor = isConfirmed ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.videocam_outlined, color: AppColors.textSecondary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status.toLowerCase(),
              style: AppTypography.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
