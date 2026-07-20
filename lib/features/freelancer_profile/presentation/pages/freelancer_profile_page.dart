import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/portfolio_gallery.dart';
import '../widgets/reviews_list.dart';

class FreelancerProfilePage extends StatelessWidget {
  final UserModel? user;

  const FreelancerProfilePage({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user != null ? '${user!.profile?.firstName} ${user!.profile?.lastName}'.trim() : 'Freelancer';
    final title = user?.profile?.title ?? 'Professional Freelancer';
    final hourlyRate = user?.profile?.hourlyRate?.toInt() ?? 0;
    final location = 'Remote'; // From backend later
    final displayImageUrl = user?.profile?.avatarUrl ?? 'https://i.pravatar.cc/150?img=5';
    final bio = user?.profile?.bio ?? 'Passionate freelancer ready to work on amazing projects.';
    final skills = user?.profile?.skills ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Padding for sticky bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: ProfileHeader(
                    name: displayName.isEmpty ? 'Freelancer' : displayName,
                    title: title,
                    hourlyRate: hourlyRate,
                    location: location,
                    imageUrl: displayImageUrl,
                    isTopRated: (user?.profile?.averageRating ?? 0.0) >= 4.8,
                  ),
                ),
                const SizedBox(height: 32),
                
                // About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: AppTypography.headingMedium.copyWith(
                          color: const Color(0xFF111827),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        bio,
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF4B5563),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (skills.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: skills.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 40),
                
                // Portfolio Section
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: PortfolioGallery(),
                ),
                
                const SizedBox(height: 40),
                
                // Reviews Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ReviewsList(),
                ),
              ],
            ),
          ),
          
          // Sticky Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF374151)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Hire ${user?.profile?.firstName ?? 'Freelancer'}',
                            style: AppTypography.buttonLarge.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
