import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/proposals_bloc.dart';
import '../bloc/proposals_event.dart';
import '../bloc/proposals_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProposalsListPage extends StatefulWidget {
  final String jobId;
  const ProposalsListPage({super.key, required this.jobId});

  @override
  State<ProposalsListPage> createState() => _ProposalsListPageState();
}

class _ProposalsListPageState extends State<ProposalsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProposalsBloc>().add(ProposalsFetchRequested(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Review Proposals',
          style: AppTypography.headingMedium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProposalsBloc, ProposalsState>(
        builder: (context, state) {
          if (state.status == ProposalsStatus.initial ||
              state.status == ProposalsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProposalsStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Error loading proposals'));
          }

          if (state.proposals.isEmpty) {
            return Center(
              child: Text(
                'No proposals yet.\nCheck back later!',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.proposals.length} Proposals',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sort by: Best Match',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: state.proposals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final proposal = state.proposals[index];
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'proposalDetail',
                          extra: proposal,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(proposal.freelancerImageUrl),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        proposal.freelancerName,
                                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        proposal.freelancerTitle,
                                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${proposal.matchPercentage}% Match',
                                        style: AppTypography.caption.copyWith(
                                          color: const Color(0xFF10B981),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _StatPill(
                                  icon: Icons.attach_money_rounded,
                                  label: '\$${proposal.bidAmount.toStringAsFixed(0)}',
                                ),
                                const SizedBox(width: 12),
                                _StatPill(
                                  icon: Icons.schedule_rounded,
                                  label: '${proposal.estimatedDays} Days',
                                ),
                                const Spacer(),
                                Text(
                                  timeago.format(proposal.submittedAt),
                                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              proposal.coverLetter,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
