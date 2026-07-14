import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.title,
    required this.hourlyRate,
    required this.location,
    required this.imageUrl,
    this.isTopRated = false,
  });

  final String name;
  final String title;
  final int hourlyRate;
  final String location;
  final String imageUrl;
  final bool isTopRated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 3),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            
            // Name & Badges
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: AppTypography.headingMedium.copyWith(
                      color: const Color(0xFF111827),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isTopRated)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Top Rated Talent',
                            style: AppTypography.labelMedium.copyWith(color: const Color(0xFFF59E0B)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Text(
          title,
          style: AppTypography.bodyLarge.copyWith(
            color: const Color(0xFF374151),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 18),
            const SizedBox(width: 4),
            Text(
              location,
              style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
            ),
            Text.rich(
              TextSpan(
                text: '\$$hourlyRate',
                style: AppTypography.headingSmall.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '/hr',
                    style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStat('Job Success', '98%'),
            _buildStat('Total Earned', '\$10k+'),
            _buildStat('Hours Worked', '342'),
            _buildStat('Response Time', '< 1 hr'),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.headingSmall.copyWith(
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
