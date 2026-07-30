import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../contracts/data/repositories/reviews_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../contracts/domain/entities/review_entity.dart';

class ReviewsList extends StatefulWidget {
  final String userId;

  const ReviewsList({super.key, required this.userId});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  late Future<List<ReviewEntity>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = context.read<ReviewsRepository>().getReviewsForUser(widget.userId).then(
      (data) => data.map((json) => ReviewEntity.fromJson(json)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewEntity>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Failed to load reviews.');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No reviews yet.', style: TextStyle(color: Colors.grey));
        }

        final reviews = snapshot.data!;
        final averageRating = reviews.fold<double>(0, (sum, item) => sum + item.rating) / reviews.length;

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
                      averageRating.toStringAsFixed(1),
                      style: AppTypography.labelLarge.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${reviews.length})',
                      style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            ...reviews.map((review) {
              return Column(
                children: [
                  _buildReviewItem(
                    '${review.reviewer?.firstName ?? 'User'} ${review.reviewer?.lastName ?? ''}'.trim(),
                    review.comment ?? 'No comment provided.',
                    _formatTimeAgo(review.createdAt),
                    review.rating.toDouble(),
                  ),
                  if (review != reviews.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0xFFE5E7EB)),
                    ),
                ],
              );
            }).toList(),
            if (reviews.length > 5) ...[
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Show all ${reviews.length} reviews'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()} years ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()} months ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'Just now';
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
                clientName.isNotEmpty ? clientName[0] : 'U',
                style: AppTypography.labelMedium.copyWith(color: const Color(0xFF4B5563)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                clientName.isNotEmpty ? clientName : 'Unknown User',
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
            (index) => Icon(
              index < rating ? Icons.star_rounded : Icons.star_border_rounded,
              color: const Color(0xFFF59E0B),
              size: 16,
            ),
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
