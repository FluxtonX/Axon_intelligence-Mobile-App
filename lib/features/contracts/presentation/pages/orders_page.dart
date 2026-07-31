import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';
import '../../domain/entities/contract_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/countdown_timer_text.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ContractsBloc>().add(const FetchMyContracts());
  }

  Widget _buildContractsList(List<ContractEntity> contracts, bool isClient) {
    if (contracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No orders in this category',
              style: AppTypography.headingSmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ContractsBloc>().add(const FetchMyContracts());
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
      itemCount: contracts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final contract = contracts[index];
        final counterpartName = isClient
            ? (contract.proposal?.freelancerName ?? 'Freelancer')
            : (contract.project?.client?['profile']?['firstName'] ?? 'Client');
            
        final title = contract.project?.title ?? 'Untitled Project';
        final isCompleted = contract.status == 'COMPLETED';
        final isPending = contract.status == 'PENDING_PAYMENT';
        
        Color statusColor = AppColors.primary;
        if (isCompleted) statusColor = const Color(0xFF10B981);
        else if (isPending) statusColor = const Color(0xFFF59E0B);

        String displayStatus = contract.status.replaceAll('_', ' ').toUpperCase();

        return GestureDetector(
          onTap: () {
            context.pushNamed(
              'contract_detail',
              extra: {'contract': contract},
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
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
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.headingSmall.copyWith(
                          color: const Color(0xFF111827),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayStatus,
                        style: AppTypography.labelMedium.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isClient ? 'Freelancer: $counterpartName' : 'Client: $counterpartName',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount: \$${contract.amount.toStringAsFixed(0)}',
                      style: AppTypography.labelLarge.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (contract.deadline != null && contract.status != 'COMPLETED')
                      CountdownTimerText(deadline: contract.deadline!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isClient = context.watch<UserModeCubit>().state == UserMode.client;
    final currentUserId = context.watch<AuthBloc>().state.user?.id;

    return BlocBuilder<ContractsBloc, ContractsState>(
      builder: (context, state) {
        if (state.status == ContractsStatus.loading || state.status == ContractsStatus.initial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == ContractsStatus.failure) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                state.errorMessage ?? 'Failed to load contracts.',
                style: AppTypography.bodyMedium,
              ),
            ),
          );
        }

        final activeContracts = state.contracts.where((c) => 
          c.status == 'ACTIVE' || c.status == 'IN_PROGRESS'
        ).toList();

        final pendingContracts = state.contracts.where((c) => 
          c.status == 'PENDING_PAYMENT' || c.status == 'PENDING'
        ).toList();
        
        final cancelledContracts = state.contracts.where((c) => 
          c.status == 'CANCELLED' || c.status == 'DISPUTED'
        ).toList();

        // Fiverr style review logic:
        // A contract is waiting for review if it's SUBMITTED, 
        // OR it's COMPLETED but the CURRENT USER hasn't reviewed it yet.
        final reviewContracts = state.contracts.where((c) {
          if (c.status == 'SUBMITTED') return true;
          if (c.status == 'COMPLETED') {
            final hasReviewed = c.reviews?.any((r) => r.reviewerId == currentUserId) ?? false;
            return !hasReviewed;
          }
          return false;
        }).toList();

        // Completed contracts ONLY show up here if they are COMPLETED AND the user has reviewed them.
        final completedContracts = state.contracts.where((c) {
          if (c.status == 'COMPLETED') {
            final hasReviewed = c.reviews?.any((r) => r.reviewerId == currentUserId) ?? false;
            return hasReviewed;
          }
          return false;
        }).toList();

        // Build dynamic tabs
        final List<Tab> tabs = [
          const Tab(text: 'Active'),
        ];
        final List<Widget> tabViews = [
          _buildContractsList(activeContracts, isClient),
        ];

        // Only add "Waiting for Review" if there are actually contracts that need reviewing
        if (reviewContracts.isNotEmpty) {
          tabs.add(const Tab(text: 'Review'));
          tabViews.add(_buildContractsList(reviewContracts, isClient));
        }

        tabs.addAll([
          const Tab(text: 'Pending'),
          const Tab(text: 'Completed'),
          const Tab(text: 'Cancelled'),
        ]);

        tabViews.addAll([
          _buildContractsList(pendingContracts, isClient),
          _buildContractsList(completedContracts, isClient),
          _buildContractsList(cancelledContracts, isClient),
        ]);

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
                  isClient ? 'Orders' : 'My Contracts',
                  style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.primary,
                unselectedLabelColor: const Color(0xFF9CA3AF),
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PlusJakartaSans'),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'PlusJakartaSans'),
                tabs: tabs,
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
