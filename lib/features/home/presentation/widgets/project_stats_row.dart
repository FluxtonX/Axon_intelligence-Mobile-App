import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ProjectStatsRow extends StatelessWidget {
  const ProjectStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: 3,
            label: 'Open',
            icon: Icons.work_outline_rounded,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: 1,
            label: 'Drafts',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFF59E0B), // Warning Orange
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: 1,
            label: 'In Review',
            icon: Icons.schedule_rounded,
            iconColor: const Color(0xFF8B5CF6), // Purple
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final int count;
  final String label;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                count.toString(),
                style: AppTypography.headingLarge.copyWith(
                  color: AppColors.textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
