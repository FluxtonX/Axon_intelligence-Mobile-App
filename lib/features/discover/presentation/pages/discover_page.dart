import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../../shared/animations/fade_in_slide.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';
import '../bloc/discover_state.dart';
import '../widgets/search_input_bar.dart';
import '../widgets/searching_indicator.dart';
import '../widgets/talent_result_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/project_result_card.dart';
import '../../data/repositories/discover_repository.dart';
import '../../../projects/data/repositories/project_repository.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/project_model.dart';
import 'package:go_router/go_router.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverBloc(
        context.read<DiscoverRepository>(),
        context.read<ProjectRepository>(),
      )..add(DiscoverStarted(context.read<UserModeCubit>().state)),
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
                            context.read<DiscoverBloc>().add(DiscoverSearchInitiated(
                              query,
                              context.read<UserModeCubit>().state,
                            ));
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
              child: BlocBuilder<UserModeCubit, UserMode>(
                builder: (context, userMode) {
                  return BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      if (state.status == DiscoverStatus.initial) {
                        return userMode == UserMode.client 
                          ? _DiscoverStorefront(topFreelancers: state.topFreelancers)
                          : _DiscoverProjectsStorefront(projects: state.availableProjects);
                      } else if (state.status == DiscoverStatus.searching) {
                        return const SearchingIndicator();
                      } else {
                        return _buildResults(context, state, userMode);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, DiscoverState state, UserMode userMode) {
    if (userMode == UserMode.client) {
      final results = state.results;
      
      if (results.isEmpty) {
        return Center(
          child: Text(
            'No freelancers found for "${state.query}"',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Results for "${state.query}"',
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
                final user = results[index];
                return TalentResultCard(
                  user: user,
                  name: '${user.profile?.firstName} ${user.profile?.lastName}',
                  title: user.profile?.title ?? 'Freelancer',
                  hourlyRate: (user.profile?.hourlyRate?.toInt() ?? 0),
                  rating: user.profile?.averageRating ?? 0.0,
                  reviewCount: user.profile?.totalReviews ?? 0,
                  location: 'Remote', // Could be added to profile later
                  skills: user.profile?.skills ?? [],
                  imageUrl: user.profile?.avatarUrl ?? 'https://i.pravatar.cc/150?img=${index % 70}',
                  matchPercentage: ((user.profile?.averageRating ?? 4.0) * 18 + (user.id.hashCode % 10)).toInt().clamp(70, 99),
                  isVerified: true,
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Freelancer Mode Results
      final results = state.projectResults;
      
      if (results.isEmpty) {
        return Center(
          child: Text(
            'No projects found for "${state.query}"',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Results for "${state.query}"',
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
                return ProjectResultCard(project: results[index]);
              },
            ),
          ),
        ],
      );
    }
  }
}

class _DiscoverProjectsStorefront extends StatelessWidget {
  final List<ProjectModel> projects;

  const _DiscoverProjectsStorefront({required this.projects});

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
        
        // Latest Projects
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Projects',
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
        if (projects.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ))
        else
          ...projects.map((project) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ProjectResultCard(project: project),
            );
          }),
      ],
    );
  }
}

class _DiscoverStorefront extends StatelessWidget {
  final List<UserModel> topFreelancers;

  const _DiscoverStorefront({required this.topFreelancers});

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
        if (topFreelancers.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ))
        else
          ...topFreelancers.map((user) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TalentResultCard(
                user: user,
                name: '${user.profile?.firstName} ${user.profile?.lastName}',
                title: user.profile?.title ?? 'Freelancer',
                hourlyRate: (user.profile?.hourlyRate?.toInt() ?? 0),
                rating: user.profile?.averageRating ?? 0.0,
                reviewCount: user.profile?.totalReviews ?? 0,
                location: 'Remote',
                skills: user.profile?.skills ?? [],
                imageUrl: user.profile?.avatarUrl ?? 'https://i.pravatar.cc/150?img=${user.id.hashCode % 70}',
                matchPercentage: ((user.profile?.averageRating ?? 4.0) * 19 + (user.id.hashCode % 8)).toInt().clamp(80, 99),
                isTopRated: true,
                isVerified: true,
                isAvailableNow: true,
              ),
            );
          }),
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
