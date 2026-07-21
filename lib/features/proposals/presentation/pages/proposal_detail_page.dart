import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/proposal_entity.dart';

class ProposalDetailPage extends StatelessWidget {
  final ProposalEntity proposal;

  const ProposalDetailPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF111827)),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Freelancer Info)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(proposal.freelancerImageUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proposal.freelancerName,
                              style: AppTypography.headingMedium.copyWith(fontSize: 22, color: const Color(0xFF111827)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              proposal.freelancerTitle,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text(
                                  proposal.freelancerRating.toString(),
                                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'View Profile',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(color: Color(0xFFE5E7EB)),
                ),

                // Bid Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BidStatCard(
                          title: 'Bid Amount',
                          value: '\$${proposal.bidAmount.toStringAsFixed(0)}',
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _BidStatCard(
                          title: 'Delivery',
                          value: '${proposal.estimatedDays} Days',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Cover Letter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cover Letter',
                        style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        proposal.coverLetter,
                        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF111827), height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Go to Interview / Chat screen
                        context.pushNamed('chatDetail', pathParameters: {
                          'id': proposal.freelancerId,
                        }, extra: {
                          'name': proposal.freelancerName,
                          'avatarUrl': proposal.freelancerImageUrl,
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Interview',
                        style: AppTypography.buttonLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Hire Now',
                      showIcon: false,
                      onTap: () {
                        // Go directly to hire contract setup with this freelancer
                        context.pushNamed('hire', extra: {
                          'proposal': proposal,
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BidStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _BidStatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.headingMedium.copyWith(color: const Color(0xFF111827))),
        ],
      ),
    );
  }
}
