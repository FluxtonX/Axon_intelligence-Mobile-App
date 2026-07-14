import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/escrow_summary_banner.dart';
import '../widgets/contract_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserModeCubit, UserMode>(
      builder: (context, userMode) {
        final isClient = userMode == UserMode.client;
        
        final List<Tab> tabs = isClient 
          ? const [
              Tab(text: 'Active'),
              Tab(text: 'In Review'),
              Tab(text: 'Published'),
              Tab(text: 'Drafts'),
              Tab(text: 'Completed'),
            ]
          : const [
              Tab(text: 'Active'),
              Tab(text: 'In Review'),
              Tab(text: 'Proposals'),
              Tab(text: 'Completed'),
            ];

        final List<Widget> tabViews = isClient
          ? const [
              _ActiveProjectsTab(),
              _InReviewProjectsTab(),
              _PublishedProjectsTab(),
              _DraftProjectsTab(),
              _CompletedProjectsTab(),
            ]
          : const [
              _ActiveProjectsTab(),
              _InReviewProjectsTab(),
              _ProposalsProjectsTab(),
              _CompletedProjectsTab(),
            ];

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Projects',
                  style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.textDark,
                      labelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                      unselectedLabelColor: const Color(0xFF6B7280),
                      unselectedLabelStyle: AppTypography.labelLarge,
                      dividerColor: Colors.transparent,
                      padding: const EdgeInsets.all(4),
                      tabs: tabs,
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: tabViews,
            ),
          ),
        );
      },
    );
  }
}

class _ActiveProjectsTab extends StatelessWidget {
  const _ActiveProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        EscrowSummaryBanner(totalAmount: 3250.00),
        SizedBox(height: 32),
        Text(
          'Active Contracts',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16),
        ContractCard(
          title: 'UI/UX Design for Mobile App',
          freelancerName: 'Sophia Chen',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          status: 'Milestone 2/3',
          escrowAmount: 1500.00,
          progress: 0.66,
        ),
        ContractCard(
          title: 'Backend API Development - Node.js',
          freelancerName: 'Marcus Williams',
          avatarUrl: 'https://i.pravatar.cc/150?img=11',
          status: 'In Progress',
          escrowAmount: 1750.00,
          progress: 0.25,
        ),
      ],
    );
  }
}

class _InReviewProjectsTab extends StatelessWidget {
  const _InReviewProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        ContractCard(
          title: 'E-commerce App Onboarding',
          freelancerName: 'Emily Clark',
          avatarUrl: 'https://i.pravatar.cc/150?img=9',
          status: 'Pending Approval',
          escrowAmount: 450.00,
          progress: 0.90,
        ),
      ],
    );
  }
}

class _PublishedProjectsTab extends StatelessWidget {
  const _PublishedProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildPublishedItem('AI Data Scientist for Model Tuning', '3 Proposals'),
        _buildPublishedItem('React Native Developer (Senior)', '12 Proposals'),
      ],
    );
  }

  Widget _buildPublishedItem(String title, String proposals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headingSmall.copyWith(
                    color: const Color(0xFF111827),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posted 2 days ago',
                  style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              proposals,
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DraftProjectsTab extends StatelessWidget {
  const _DraftProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_document, color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fintech Landing Page',
                      style: AppTypography.headingSmall.copyWith(
                        color: const Color(0xFF111827),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last edited 3 hours ago',
                      style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF9CA3AF), size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompletedProjectsTab extends StatelessWidget {
  const _CompletedProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        ContractCard(
          title: 'Brand Identity & Logo Design',
          freelancerName: 'Yuki Tanaka',
          avatarUrl: 'https://i.pravatar.cc/150?img=12',
          status: 'Completed',
          escrowAmount: 0.00,
          progress: 1.0,
          isActive: false,
        ),
        ContractCard(
          title: 'Smart Contract Audit',
          freelancerName: 'TechNova Agency',
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
          status: 'Completed',
          escrowAmount: 0.00,
          progress: 1.0,
          isActive: false,
        ),
      ],
    );
  }
}

class _ProposalsProjectsTab extends StatelessWidget {
  const _ProposalsProjectsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildProposalItem('Senior Flutter Engineer', 'Submitted 1 day ago', 'Pending'),
        _buildProposalItem('E-Commerce App Redesign', 'Submitted 3 days ago', 'Interviewing', isHighlight: true),
        _buildProposalItem('Dashboard UI/UX', 'Submitted 1 week ago', 'Archived'),
      ],
    );
  }

  Widget _buildProposalItem(String title, String time, String status, {bool isHighlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isHighlight ? AppColors.primary : const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headingSmall.copyWith(
                    color: const Color(0xFF111827),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isHighlight ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: AppTypography.caption.copyWith(
                color: isHighlight ? AppColors.primary : const Color(0xFF4B5563),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
