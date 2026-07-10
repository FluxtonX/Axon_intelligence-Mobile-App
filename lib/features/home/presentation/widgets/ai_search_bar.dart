import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';

class AISearchBar extends StatelessWidget {
  const AISearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ai_project_creation'),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6FF), // Very light blue tint
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            // AI Icon Placeholder (or actual Axon logo icon if available)
            Icon(
              Icons.auto_awesome, // Represents AI
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Describe the talent you need...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
