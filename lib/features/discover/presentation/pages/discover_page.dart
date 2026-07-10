import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';
import '../widgets/search_input_bar.dart';
import '../widgets/searching_indicator.dart';
import '../widgets/talent_result_card.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Talent',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    // Empty Initial State
                    return Center(
                      child: Text(
                        'Start typing to search for freelancers.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  } else if (state.status == DiscoverStatus.searching) {
                    // Animated Searching State
                    return const SearchingIndicator();
                  } else {
                    // Results State
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
        title: 'Full-Stack Engineer - AI & Web3 Spec',
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
      const TalentResultCard(
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
      const TalentResultCard(
        name: 'Priya Sharma',
        title: 'Data Scientist & ML Engineer',
        hourlyRate: 130,
        rating: 4.94,
        reviewCount: 28,
        location: 'Bangalore',
        skills: ['Python', 'TensorFlow', 'PyTorch'],
        imageUrl: 'https://i.pravatar.cc/150?img=9',
        matchPercentage: 74,
        isVerified: true,
        isAvailableNow: true,
      ),
    ];

    return Column(
      children: [
        // Results Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top results',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.textDark),
                    ),
                    Text(
                      'AI found ${results.length} matches for "$query"',
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Filter Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Filter',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Scrollable List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
