import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            label: 'Create Project',
            icon: Icons.add_rounded,
            iconColor: AppColors.primary,
            onTap: () => context.push('/ai_project_creation'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            label: 'Find Talent',
            icon: Icons.search_rounded,
            iconColor: const Color(0xFF10B981), // Emerald Green
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            label: 'Hire',
            icon: Icons.person_add_alt_1_rounded,
            iconColor: const Color(0xFF8B5CF6), // Purple
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF3F4F6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
