import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/activity_tile.dart';
import '../widgets/ai_search_bar.dart';
import '../widgets/hiring_spend_card.dart';
import '../widgets/home_header.dart';
import '../widgets/interview_card.dart';
import '../widgets/project_stats_row.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/talent_card.dart';
import '../../../auth/data/auth_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeDataFetched()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final authRepo = RepositoryProvider.of<AuthRepository>(context);
            final isLoggedIn = authRepo.isLoggedIn();
            final isActive = state.status == HomeStatus.active && isLoggedIn;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeDataFetched());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: HomeHeader()),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── AI Search ───────────────────────────────────
                    const AISearchBar(),
                    const SizedBox(height: 32),

                    // ── Active Dashboard Only ───────────────────────
                    if (isActive) ...[
                      const HiringSpendCard(),
                      const SizedBox(height: 24),
                      const ProjectStatsRow(),
                      const SizedBox(height: 24),
                    ],

                    // ── Quick Actions ───────────────────────────────
                    if (isActive) ...[
                      const QuickActionsRow(),
                      const SizedBox(height: 32),
                    ],

                    // ── Empty State Specific ────────────────────────
                    if (!isActive) ...[
                      _buildEmptyStateIntro(),
                      const SizedBox(height: 32),
                      const QuickActionsRow(), // Keep Create/Find buttons
                      const SizedBox(height: 32),
                      _buildPopularCategories(),
                      const SizedBox(height: 32),
                    ],

                    // ── Active Dashboard Content ────────────────────
                    if (isActive) ...[
                      _buildSectionHeader('Waiting for Your Review', 'See all'),
                      const SizedBox(height: 16),
                      _buildReviewCard(),
                      const SizedBox(height: 32),

                      _buildSectionHeader('AI Recommended Talent', 'See all'),
                      const SizedBox(height: 4),
                      Text(
                        '✦ Matched to your open projects',
                        style: AppTypography.caption.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      _buildTalentList(),
                      const SizedBox(height: 32),

                      _buildSectionHeader('Upcoming Interviews', 'Schedule'),
                      const SizedBox(height: 16),
                      const InterviewCard(
                        name: 'Sophia Chen',
                        time: 'Today • 3:00 PM',
                        status: 'Confirmed',
                        imageUrl: 'https://i.pravatar.cc/150?img=5',
                      ),
                      const InterviewCard(
                        name: 'Priya Sharma',
                        time: 'Tomorrow • 11:00 AM',
                        status: 'Pending',
                        imageUrl: 'https://i.pravatar.cc/150?img=9',
                      ),
                      const InterviewCard(
                        name: 'Marcus Williams',
                        time: 'Jul 11 • 2:30 PM',
                        status: 'Confirmed',
                        imageUrl: 'https://i.pravatar.cc/150?img=11',
                      ),
                      const SizedBox(height: 32),

                      _buildSectionHeader('Recent Activity', null),
                      const SizedBox(height: 16),
                      const ActivityTile(
                        type: ActivityType.application,
                        description: 'Amara Osei applied to Growth Marketing Retainer',
                        timeAgo: '2h ago',
                      ),
                      const ActivityTile(
                        type: ActivityType.milestone,
                        description: 'You approved milestone "Visual Identity"',
                        timeAgo: '5h ago',
                      ),
                      const ActivityTile(
                        type: ActivityType.message,
                        description: 'New message from Marcus Williams',
                        timeAgo: '6h ago',
                      ),
                      const ActivityTile(
                        type: ActivityType.shortlist,
                        description: 'You shortlisted Sophia Chen',
                        timeAgo: '1d ago',
                      ),
                      const ActivityTile(
                        type: ActivityType.completion,
                        description: 'Project "iOS Launch Campaign" was completed',
                        timeAgo: '2d ago',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helper UI Builders ──────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        if (action != null)
          Text(
            action,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.assignment_turned_in_rounded, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brand Identity System',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Deliverable ready - Yuki Tanaka',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildTalentList() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: const [
          TalentCard(
            name: 'Sophia Chen',
            title: 'Product Designer & Brand Strategist',
            rate: 120,
            rating: 4.98,
            matchPercentage: 98,
            skills: ['Product Design', 'Figma'],
            imageUrl: 'https://i.pravatar.cc/150?img=5',
          ),
          SizedBox(width: 16),
          TalentCard(
            name: 'Marcus Williams',
            title: 'Full-Stack Engineer - AI / React Specialist',
            rate: 155,
            rating: 4.95,
            matchPercentage: 95,
            skills: ['React', 'TypeScript'],
            imageUrl: 'https://i.pravatar.cc/150?img=11',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateIntro() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to hire your first expert?',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Describe your project in the AI search bar above, and we will instantly match you with top verified freelancers.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCategories() {
    final categories = ['Mobile App Dev', 'UI/UX Design', 'AI Engineering', 'Brand Identity', 'SEO'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Categories',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((cat) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                cat,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

