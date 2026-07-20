import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/animations/fade_in_slide.dart';
import '../widgets/escrow_summary_banner.dart';
import '../widgets/contract_card.dart';
import '../bloc/client_projects_bloc.dart';
import '../bloc/client_projects_state.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../../contracts/presentation/bloc/contracts_event.dart';
import '../../../contracts/presentation/bloc/contracts_state.dart';
import '../../../contracts/domain/entities/contract_entity.dart';
import '../../../../core/models/project_model.dart';
import 'package:go_router/go_router.dart';

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

class _ActiveProjectsTab extends StatefulWidget {
  const _ActiveProjectsTab();

  @override
  State<_ActiveProjectsTab> createState() => _ActiveProjectsTabState();
}

class _ActiveProjectsTabState extends State<_ActiveProjectsTab> {
  @override
  void initState() {
    super.initState();
    context.read<ContractsBloc>().add(const FetchMyContracts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractsBloc, ContractsState>(
      builder: (context, state) {
        if (state.status == ContractsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ContractsStatus.failure) {
          return Center(child: Text('Failed to load contracts: ${state.errorMessage}'));
        }

        final activeContracts = state.contracts
            .where((c) => c.status == 'ACTIVE' || c.status == 'SUBMITTED')
            .toList();

        final totalEscrow = activeContracts.fold(0.0, (sum, c) => sum + c.amount);

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            EscrowSummaryBanner(totalAmount: totalEscrow),
            const SizedBox(height: 32),
            const Text(
              'Active Contracts',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            if (activeContracts.isEmpty)
              const Center(child: Text('No active contracts right now.'))
            else
              ...activeContracts.map((contract) {
                final isClient = context.read<UserModeCubit>().state == UserMode.client;
                final counterpartyName = isClient
                    ? (contract.proposal?.freelancerName ?? 'Freelancer')
                    : (contract.project?.client?['profile']?['firstName'] ?? 'Client');
                final title = contract.project?.title ?? 'Project';

                return GestureDetector(
                  onTap: () {
                    context.pushNamed('contract_detail', extra: {'contract': contract});
                  },
                  child: ContractCard(
                    title: title,
                    freelancerName: counterpartyName,
                    avatarUrl: 'https://i.pravatar.cc/150?u=${contract.id}',
                    status: contract.status,
                    escrowAmount: contract.amount,
                    progress: contract.status == 'SUBMITTED' ? 0.9 : 0.5,
                  ),
                );
              }),
          ],
        );
      },
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
    return BlocBuilder<ClientProjectsBloc, ClientProjectsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state.projects.isEmpty) {
          return const Center(child: Text('No published projects yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: state.projects.map((project) {
            return _buildPublishedItem(project);
          }).toList(),
        );
      },
    );
  }

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return 'Posted ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    if (difference.inHours > 0) return 'Posted ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    if (difference.inMinutes > 0) return 'Posted ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    return 'Posted just now';
  }

  Widget _buildPublishedItem(ProjectModel project) {
    final clientName = project.client?['profile']?['firstName'] ?? 'You';
    final lastName = project.client?['profile']?['lastName'] ?? '';
    final fullName = lastName.isNotEmpty ? '$clientName $lastName' : clientName;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: AppTypography.headingSmall.copyWith(
                        color: const Color(0xFF111827),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'By $fullName',
                          style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '•',
                          style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                        ),
                        Text(
                          _timeAgo(project.createdAt),
                          style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '0 Proposals', // TODO: hook up proposals count
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Budget: \$${project.budget.toStringAsFixed(0)} • Timeline: ${project.timeline ?? "Flexible"}',
            style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
          ),
          if (project.skills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: AppTypography.caption.copyWith(color: const Color(0xFF4B5563), fontSize: 11),
                  ),
                );
              }).toList(),
            ),
          ],
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
    return BlocBuilder<ContractsBloc, ContractsState>(
      builder: (context, state) {
        if (state.status == ContractsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ContractsStatus.failure) {
          return Center(child: Text('Failed to load contracts: ${state.errorMessage}'));
        }

        final completedContracts = state.contracts
            .where((c) => c.status == 'COMPLETED')
            .toList();

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Completed Contracts',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            if (completedContracts.isEmpty)
              const Center(child: Text('No completed contracts yet.'))
            else
              ...completedContracts.map((contract) {
                final isClient = context.read<UserModeCubit>().state == UserMode.client;
                final counterpartyName = isClient
                    ? (contract.proposal?.freelancerName ?? 'Freelancer')
                    : (contract.project?.client?['profile']?['firstName'] ?? 'Client');
                final title = contract.project?.title ?? 'Project';

                return GestureDetector(
                  onTap: () {
                    context.pushNamed('contract_detail', extra: {'contract': contract});
                  },
                  child: ContractCard(
                    title: title,
                    freelancerName: counterpartyName,
                    avatarUrl: 'https://i.pravatar.cc/150?u=${contract.id}',
                    status: contract.status,
                    escrowAmount: contract.amount,
                    progress: 1.0,
                    isActive: false,
                  ),
                );
              }),
          ],
        );
      },
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
