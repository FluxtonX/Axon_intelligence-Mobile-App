import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Picture
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?img=11'),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          ),
        ),
        const SizedBox(width: 12),
        // Greeting & Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Meridian Finance',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        // Notification Bell
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3F4F6), // Light gray background
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textDark,
                size: 24,
              ),
            ),
            // Notification Badge (Red dot)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
