import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/bloc/services_event.dart';
import '../../../services/presentation/bloc/services_state.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../../contracts/presentation/bloc/contracts_event.dart';
import '../../../contracts/presentation/bloc/contracts_state.dart';
import '../../../contracts/presentation/widgets/countdown_timer_text.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key});

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    context.read<ServicesBloc>().add(LoadMyServices());
    context.read<ContractsBloc>().add(const FetchMyContracts());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Freelancer Mode',
                          style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dashboard',
                          style: AppTypography.headingSmall.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String avatarUrl = 'https://ui-avatars.com/api/?name=U&background=3B6EF5&color=fff';
                        if (state is ProfileLoaded) {
                          final profile = state.user.profile;
                          if (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty) {
                            avatarUrl = profile.avatarUrl!;
                          } else {
                            final name = profile != null ? '${profile.firstName} ${profile.lastName}'.trim() : 'U';
                            avatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name.isEmpty ? 'U' : name)}&background=3B6EF5&color=fff';
                          }
                        }
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFEEF2FF),
                          backgroundImage: NetworkImage(avatarUrl),
                        );
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Earnings Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Earnings Overview', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Withdraw Funds'),
                            content: const Text('Please visit our web portal to manage your payouts and withdraw funds.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: _DashboardStatCard(
                        title: 'Available for Withdrawal',
                        amount: '\$0.00',
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _DashboardStatCard(
                      title: 'Pending Escrow',
                      amount: '\$850.00',
                      icon: Icons.security_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    _DashboardStatCard(
                      title: 'Completed This Month',
                      amount: '4',
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // My Services
              BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  if (state is ServicesLoading) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  
                  if (state is ServicesLoaded && state.services.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text('My Services', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.services.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final service = state.services[index];
                              return _ServiceCard(gig: service);
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  }
                  
                  return const SizedBox.shrink(); // Hide if no services
                },
              ),

              // Active Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Submitted Proposals', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
                    TextButton(
                      onPressed: () => context.pushNamed('submittedProposals'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View All',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => context.pushNamed('submittedProposals'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Track Proposals',
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Review your active bids',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9CA3AF)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Active Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Orders', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
                    Text(
                      'View All',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ContractsBloc, ContractsState>(
                builder: (context, state) {
                  if (state.status == ContractsStatus.loading) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  
                  final activeContracts = state.contracts.where((c) => 
                    c.status == 'ACTIVE' || c.status == 'PENDING' || c.status == 'PENDING_PAYMENT'
                  ).toList();

                  if (activeContracts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('No active orders right now.', style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280))),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: activeContracts.map((contract) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed('contract_detail', extra: {'contract': contract});
                            },
                            child: _ActiveOrderCard(
                              clientName: contract.project?.client?['profile']?['firstName'] ?? 'Client',
                              projectTitle: contract.project?.title ?? 'Gig Order',
                              price: '\$${contract.amount.toStringAsFixed(0)}',
                              deadline: contract.deadline,
                              progress: 0.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Profile Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Performance', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _PerformanceStat(label: 'Profile Views', value: '1.2k', trend: '+12%')),
                      Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                      Expanded(child: _PerformanceStat(label: 'Response Rate', value: '98%', trend: 'Good')),
                      Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                      Expanded(child: _PerformanceStat(label: 'Order Success', value: '100%', trend: 'Perfect')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _DashboardStatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Text(title, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(amount, style: AppTypography.headingMedium.copyWith(fontSize: 24, color: const Color(0xFF111827))),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  final String clientName;
  final String projectTitle;
  final String price;
  final DateTime? deadline;
  final double progress;

  const _ActiveOrderCard({
    required this.clientName,
    required this.projectTitle,
    required this.price,
    this.deadline,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(clientName, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
              if (deadline != null) CountdownTimerText(deadline: deadline!),
            ],
          ),
          const SizedBox(height: 8),
          Text(projectTitle, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              Text('${(progress * 100).toInt()}% Complete', style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceStat extends StatelessWidget {
  final String label;
  final String value;
  final String trend;

  const _PerformanceStat({required this.label, required this.value, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.headingMedium.copyWith(fontSize: 20, color: const Color(0xFF111827))),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
        const SizedBox(height: 4),
        Text(trend, style: AppTypography.caption.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceEntity gig;

  const _ServiceCard({required this.gig});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            height: 100,
            width: double.infinity,
            color: const Color(0xFFF3F4F6),
            child: const Icon(Icons.image_outlined, color: Color(0xFF9CA3AF), size: 32),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gig.category,
                  style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  gig.title,
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${gig.price.toStringAsFixed(0)}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text('${gig.deliveryDays} Days', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
