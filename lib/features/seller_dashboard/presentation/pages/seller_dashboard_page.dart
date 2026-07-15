import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../gig_creation/presentation/bloc/gig_creation_bloc.dart';
import '../../gig_creation/presentation/bloc/gig_creation_state.dart';
import '../../gig_creation/domain/entities/gig_entity.dart';

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=68'),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Earnings Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Earnings Overview', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _DashboardStatCard(
                      title: 'Available for Withdrawal',
                      amount: '\$1,240.00',
                      icon: Icons.account_balance_wallet_rounded,
                      color: const Color(0xFF10B981),
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
              BlocBuilder<GigCreationBloc, GigCreationState>(
                builder: (context, state) {
                  if (state.gigs.isEmpty) {
                    return const SizedBox.shrink(); // Hide if no services
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text('My Services', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.gigs.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final gig = state.gigs[index];
                            return _ServiceCard(gig: gig);
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),

              // Active Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Orders', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
                    Text(
                      'View All',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _ActiveOrderCard(
                      clientName: 'Alex Mercer',
                      projectTitle: 'E-commerce App UI/UX Design',
                      price: '\$1,200',
                      dueDate: 'In 3 days',
                      progress: 0.8,
                    ),
                    const SizedBox(height: 16),
                    _ActiveOrderCard(
                      clientName: 'TechStart Inc.',
                      projectTitle: 'Flutter App Migration',
                      price: '\$3,500',
                      dueDate: 'In 12 days',
                      progress: 0.3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Profile Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Performance', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('createGig'),
        backgroundColor: const Color(0xFF111827),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Create Service', style: AppTypography.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
  final String dueDate;
  final double progress;

  const _ActiveOrderCard({
    required this.clientName,
    required this.projectTitle,
    required this.price,
    required this.dueDate,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Text(dueDate, style: AppTypography.caption.copyWith(color: const Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
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
  final GigEntity gig;

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
