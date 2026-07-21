import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/proposal_repository.dart';
import '../bloc/submitted_proposals_bloc.dart';
import '../bloc/submitted_proposals_event.dart';
import '../bloc/submitted_proposals_state.dart';

class SubmittedProposalsPage extends StatefulWidget {
  const SubmittedProposalsPage({super.key});

  @override
  State<SubmittedProposalsPage> createState() => _SubmittedProposalsPageState();
}

class _SubmittedProposalsPageState extends State<SubmittedProposalsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmittedProposalsBloc(
        context.read<ProposalRepository>(),
      )..add(SubmittedProposalsFetchRequested()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9FAFB),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Submitted Proposals',
            style: AppTypography.headingSmall.copyWith(fontSize: 20, color: const Color(0xFF111827)),
          ),
        ),
        body: BlocBuilder<SubmittedProposalsBloc, SubmittedProposalsState>(
          builder: (context, state) {
            if (state.status == SubmittedProposalsStatus.initial ||
                state.status == SubmittedProposalsStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state.status == SubmittedProposalsStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.proposals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'No proposals submitted yet.',
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<SubmittedProposalsBloc>().add(SubmittedProposalsFetchRequested());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: state.proposals.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final proposal = state.proposals[index];
                  // The API might return project nested under proposal, or project title. 
                  // In our backend, we included project: { select: { title: true } }
                  final projectTitle = proposal.projectTitle ?? 'Unknown Project';
                  final statusText = proposal.status.toUpperCase();
                  final statusColor = proposal.status == 'ACCEPTED'
                      ? Colors.green
                      : proposal.status == 'REJECTED'
                          ? Colors.red
                          : AppColors.primary;

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                projectTitle,
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF111827),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildInfoChip(Icons.attach_money_rounded, '\$${proposal.bidAmount.toStringAsFixed(0)}'),
                            const SizedBox(width: 12),
                            _buildInfoChip(Icons.calendar_today_rounded, '${proposal.estimatedDays} Days'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Submitted on ${DateFormat('MMM d, y').format(proposal.submittedAt)}',
                          style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
