import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

enum ActivityType { application, milestone, message, shortlist, completion }

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.type,
    required this.description,
    required this.timeAgo,
  });

  final ActivityType type;
  final String description;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case ActivityType.application:
        icon = Icons.person_add_alt_1_rounded;
        iconColor = const Color(0xFF3B82F6); // Blue
        bgColor = const Color(0xFFEFF6FF);
        break;
      case ActivityType.milestone:
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF10B981); // Green
        bgColor = const Color(0xFFECFDF5);
        break;
      case ActivityType.message:
        icon = Icons.chat_bubble_rounded;
        iconColor = const Color(0xFF8B5CF6); // Purple
        bgColor = const Color(0xFFF5F3FF);
        break;
      case ActivityType.shortlist:
        icon = Icons.star_rounded;
        iconColor = const Color(0xFFF59E0B); // Orange
        bgColor = const Color(0xFFFFFBEB);
        break;
      case ActivityType.completion:
        icon = Icons.celebration_rounded;
        iconColor = const Color(0xFFEC4899); // Pink
        bgColor = const Color(0xFFFDF2F8);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeAgo,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
