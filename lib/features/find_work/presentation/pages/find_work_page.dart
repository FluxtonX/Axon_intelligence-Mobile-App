import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/animations/fade_in_slide.dart';

class FindWorkPage extends StatelessWidget {
  const FindWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header Area
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find Work',
                        style: AppTypography.headingSmall.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=68'),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search for projects...',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                        suffixIcon: const Icon(Icons.tune_rounded, color: Color(0xFF6B7280)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Categories
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _CategoryChip(title: 'Recommended', isSelected: true),
                        _CategoryChip(title: 'Mobile App Dev', isSelected: false),
                        _CategoryChip(title: 'UI/UX Design', isSelected: false),
                        _CategoryChip(title: 'Web3', isSelected: false),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            // Job Listings
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  FadeInSlide(
                    delay: Duration(milliseconds: 0),
                    child: _JobPostingCard(
                      title: 'Senior Flutter Developer for Fintech App',
                      clientName: 'Meridian Finance',
                      budget: '\$3,000 - \$5,000',
                      postedTime: 'Posted 2 hours ago',
                      description: 'We are looking for an experienced Flutter developer to build our new personal finance application from scratch. Must have experience with complex state management and animations.',
                      tags: ['Flutter', 'Dart', 'Firebase'],
                      proposals: '5-10 proposals',
                    ),
                  ),
                  SizedBox(height: 16),
                  FadeInSlide(
                    delay: Duration(milliseconds: 100),
                    child: _JobPostingCard(
                      title: 'UX/UI Designer for E-commerce Dashboard',
                      clientName: 'TechStart Inc.',
                      budget: '\$1,500',
                      postedTime: 'Posted 5 hours ago',
                      description: 'Need a complete redesign of our merchant dashboard. The focus should be on clean aesthetics, data visualization, and ease of use.',
                      tags: ['Figma', 'UI/UX', 'Dashboard'],
                      proposals: 'Less than 5 proposals',
                    ),
                  ),
                  SizedBox(height: 16),
                  FadeInSlide(
                    delay: Duration(milliseconds: 200),
                    child: _JobPostingCard(
                      title: 'Backend Node.js API Integration',
                      clientName: 'Global Solutions',
                      budget: '\$50/hr',
                      postedTime: 'Posted 1 day ago',
                      description: 'Looking for a backend engineer to integrate third-party payment gateways and optimize our existing REST APIs.',
                      tags: ['Node.js', 'Express', 'API'],
                      proposals: '15-20 proposals',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _CategoryChip({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF111827) : const Color(0xFFE5E7EB)),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4B5563),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _JobPostingCard extends StatelessWidget {
  final String title;
  final String clientName;
  final String budget;
  final String postedTime;
  final String description;
  final List<String> tags;
  final String proposals;

  const _JobPostingCard({
    required this.title,
    required this.clientName,
    required this.budget,
    required this.postedTime,
    required this.description,
    required this.tags,
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(postedTime, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
              const Icon(Icons.bookmark_border_rounded, color: Color(0xFF6B7280), size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.headingSmall.copyWith(color: Colors.black, fontSize: 18)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(budget, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text('•', style: TextStyle(color: Colors.grey.shade400)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(clientName, style: AppTypography.caption.copyWith(color: const Color(0xFF4B5563), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563), height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tag, style: AppTypography.caption.copyWith(color: const Color(0xFF4B5563))),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(proposals, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    'submitProposal',
                    extra: {
                      'jobTitle': title,
                      'clientName': clientName,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(120, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text('Submit Proposal', style: AppTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
