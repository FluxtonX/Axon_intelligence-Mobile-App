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
import '../../../contracts/presentation/widgets/client_review_card.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../auth/data/auth_repository.dart';
import '../../data/repositories/home_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(context.read()),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => HomeBloc(context.read<HomeRepository>())..add(const HomeDataFetched()),
            child: const _HomeView(),
          );
        }
      ),
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
                      HiringSpendCard(
                        totalSpend: state.dashboardData?.stats.totalSpend ?? 0,
                        activeContracts: state.dashboardData?.stats.activeContracts ?? 0,
                        totalHires: state.dashboardData?.stats.totalHires ?? 0,
                      ),
                      const SizedBox(height: 24),
                      ProjectStatsRow(
                        activeContracts: state.dashboardData?.stats.activeContracts ?? 0,
                        inReviewContracts: state.dashboardData?.submittedContracts.length ?? 0,
                      ),
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
                      if (state.dashboardData != null && state.dashboardData!.submittedContracts.isNotEmpty) ...[
                        _buildSectionHeader('Waiting for Your Review', 'See all'),
                        const SizedBox(height: 16),
                        ...state.dashboardData!.submittedContracts.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ClientReviewCard(contract: c),
                        )),
                        const SizedBox(height: 16),
                      ],

                      if (state.dashboardData != null && state.dashboardData!.recommendedTalent.isNotEmpty) ...[
                        _buildSectionHeader('AI Recommended Talent', 'See all'),
                        const SizedBox(height: 4),
                        Text(
                          '✦ Matched to your open projects',
                          style: AppTypography.caption.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 310,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.dashboardData!.recommendedTalent.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final talent = state.dashboardData!.recommendedTalent[index];
                              return TalentCard(
                                name: '${talent.profile?.firstName ?? ''} ${talent.profile?.lastName ?? ''}',
                                title: talent.profile?.title ?? 'Freelancer',
                                rating: talent.profile?.averageRating?.toDouble() ?? 5.0,
                                rate: (talent.profile?.hourlyRate ?? 0).toInt(),
                                matchPercentage: 95,
                                skills: talent.profile?.skills ?? [],
                                imageUrl: talent.profile?.avatarUrl ?? 'https://i.pravatar.cc/150?u=${talent.id}',
                                bio: talent.profile?.bio ?? 'Experienced professional ready to bring your ideas to life.',
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      if (state.dashboardData != null && state.dashboardData!.recentActivity.isNotEmpty) ...[
                        _buildSectionHeader('Recent Activity', null),
                        const SizedBox(height: 16),
                        ...state.dashboardData!.recentActivity.map((notif) => ActivityTile(
                          type: ActivityType.message, // Map appropriately if needed
                          description: notif.body,
                          timeAgo: timeago.format(notif.createdAt),
                        )),
                      ],
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

