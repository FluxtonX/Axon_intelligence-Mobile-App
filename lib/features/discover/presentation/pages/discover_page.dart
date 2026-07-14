import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';
import '../widgets/search_input_bar.dart';
import '../widgets/searching_indicator.dart';
import '../widgets/talent_result_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverBloc(),
      child: const _DiscoverView(),
    );
  }
}

class _DiscoverView extends StatelessWidget {
  const _DiscoverView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Area
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
                        'Discover',
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
                  BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      return SearchInputBar(
                        initialQuery: state.query,
                        onSearch: (query) {
                          if (query.isNotEmpty) {
                            context.read<DiscoverBloc>().add(DiscoverSearchInitiated(query));
                          }
                        },
                        onClear: () {
                          context.read<DiscoverBloc>().add(DiscoverSearchCleared());
                        },
                        onFilter: () => FilterBottomSheet.show(context),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: BlocBuilder<DiscoverBloc, DiscoverState>(
                builder: (context, state) {
                  if (state.status == DiscoverStatus.initial) {
                    return const _DiscoverStorefront();
                  } else if (state.status == DiscoverStatus.searching) {
                    return const SearchingIndicator();
                  } else {
                    return _buildResults(context, state.query);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, String query) {
    final results = [
      const TalentResultCard(
        name: 'Sophia Chen',
        title: 'Product Designer & Brand Strategist',
        hourlyRate: 120,
        rating: 4.98,
        reviewCount: 87,
        location: 'San Francisco',
        skills: ['Product Design', 'Figma', 'Brand Strategy'],
        imageUrl: 'https://i.pravatar.cc/150?img=5',
        matchPercentage: 96,
        isTopRated: true,
        isAvailableNow: true,
      ),
      const TalentResultCard(
        name: 'Marcus Williams',
        title: 'Full-Stack Engineer - AI & Web3',
        hourlyRate: 155,
        rating: 4.95,
        reviewCount: 42,
        location: 'New York',
        skills: ['React', 'TypeScript', 'Node.js'],
        imageUrl: 'https://i.pravatar.cc/150?img=11',
        matchPercentage: 91,
        isVerified: true,
        isAvailableNow: true,
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Text(
                'Results for "$query"',
                style: AppTypography.labelLarge.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${results.length} found',
                style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return results[index];
            },
          ),
        ),
      ],
    );
  }
}

class _DiscoverStorefront extends StatelessWidget {
  const _DiscoverStorefront();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // Categories
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Categories',
            style: AppTypography.labelLarge.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: const [
              _CategoryChip(title: 'Design & Creative', isSelected: true),
              _CategoryChip(title: 'Development & IT', isSelected: false),
              _CategoryChip(title: 'AI Services', isSelected: false),
              _CategoryChip(title: 'Marketing', isSelected: false),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Top Rated
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Rated Talent',
                style: AppTypography.labelLarge.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'See all',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: TalentResultCard(
            name: 'Priya Sharma',
            title: 'Data Scientist & ML Engineer',
            hourlyRate: 130,
            rating: 4.94,
            reviewCount: 28,
            location: 'Bangalore',
            skills: ['Python', 'TensorFlow', 'PyTorch'],
            imageUrl: 'https://i.pravatar.cc/150?img=9',
            matchPercentage: 98,
            isTopRated: true,
            isVerified: true,
            isAvailableNow: true,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: TalentResultCard(
            name: 'Yuki Tanaka',
            title: 'Motion Designer & Creative Director',
            hourlyRate: 110,
            rating: 4.97,
            reviewCount: 51,
            location: 'Tokyo',
            skills: ['Motion Design', 'After Effects', '3D Animation'],
            imageUrl: 'https://i.pravatar.cc/150?img=12',
            matchPercentage: 86,
            isVerified: true,
            isAvailableNow: true,
          ),
        ),
      ],
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
      margin: const EdgeInsets.only(right: 12),
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
          fontSize: 14,
        ),
      ),
    );
  }
}
