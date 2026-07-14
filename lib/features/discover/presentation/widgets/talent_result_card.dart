import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';

class TalentResultCard extends StatelessWidget {
  final String name;
  final String title;
  final int hourlyRate;
  final double rating;
  final int reviewCount;
  final String location;
  final List<String> skills;
  final String imageUrl;
  final int matchPercentage;
  final bool isTopRated;
  final bool isVerified;
  final bool isAvailableNow;

  const TalentResultCard({
    super.key,
    required this.name,
    required this.title,
    required this.hourlyRate,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.skills,
    required this.imageUrl,
    required this.matchPercentage,
    this.isTopRated = false,
    this.isVerified = false,
    this.isAvailableNow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/freelancer-profile'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: const Color(0xFFF3F4F6), width: 2),
                      ),
                    ),
                    if (isAvailableNow)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: AppTypography.headingSmall.copyWith(
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Heart Icon
                          const Icon(Icons.favorite_border_rounded, color: Color(0xFF9CA3AF), size: 22),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Rating & Location
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: AppTypography.labelMedium.copyWith(
                              color: const Color(0xFF111827),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ($reviewCount)',
                            style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                          ),
                          const Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 14),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              location,
                              style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          
          // Skills & Badges
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTopRated || isVerified) ...[
                  Row(
                    children: [
                      if (isTopRated)
                        _buildBadge('Top Rated', const Color(0xFFF59E0B), Icons.emoji_events_rounded),
                      if (isTopRated && isVerified) const SizedBox(width: 8),
                      if (isVerified)
                        _buildBadge('AI Verified', AppColors.primary, Icons.verified_rounded),
                      const Spacer(),
                      Text(
                        '\$$hourlyRate',
                        style: AppTypography.headingSmall.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/hr',
                        style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        skill,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
