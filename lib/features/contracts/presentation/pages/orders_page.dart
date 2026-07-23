import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContractsBloc>().add(const FetchMyContracts());
  }

  @override
  Widget build(BuildContext context) {
    final isClient = context.watch<UserModeCubit>().state == UserMode.client;

    return Scaffold(
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
      ),
      body: BlocBuilder<ContractsBloc, ContractsState>(
        builder: (context, state) {
          if (state.status == ContractsStatus.loading || state.status == ContractsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ContractsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Failed to load contracts.',
                style: AppTypography.bodyMedium,
              ),
            );
          }

          if (state.contracts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No active orders',
                    style: AppTypography.headingSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: state.contracts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final contract = state.contracts[index];
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
                      Text(
                        'Amount: \$${contract.amount.toStringAsFixed(0)}',
                        style: AppTypography.labelLarge.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
