import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';
import '../../domain/entities/contract_entity.dart';
import '../widgets/contract_timeline.dart';
import '../widgets/delivery_upload_form.dart';
import '../widgets/client_review_card.dart';

class ContractDetailPage extends StatefulWidget {
  final ContractEntity contract;

  const ContractDetailPage({super.key, required this.contract});

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  final _submissionController = TextEditingController();

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isClient = context.read<UserModeCubit>().state == UserMode.client;

    return BlocListener<ContractsBloc, ContractsState>(
      listener: (context, state) {
        if (state.actionSuccessMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionSuccessMessage!)),
          );
          context.pop(); // Go back after success
        } else if (state.status == ContractsStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Contract Details',
            style: AppTypography.headingMedium.copyWith(fontSize: 18, color: AppColors.textDark),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.contract.project?.title ?? 'Project', style: AppTypography.headingMedium.copyWith(color: AppColors.textDark)),
              const SizedBox(height: 24),
              
              // 1. Order Timeline
              ContractTimeline(
                status: widget.contract.status,
                createdAt: widget.contract.createdAt,
              ),
              const SizedBox(height: 32),

              // 2. Client: Fund Contract
              if (isClient && (widget.contract.status == 'PENDING_PAYMENT' || widget.contract.status == 'PENDING')) ...[
                Container(
                  padding: const EdgeInsets.all(20),
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.security_rounded, color: Color(0xFFD97706), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text('Fund Escrow to Start', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Fund this contract to move it to ACTIVE status and let the freelancer start working. Your money is held securely and won\'t be released until you approve the work.',
                        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<ContractsBloc, ContractsState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            label: 'Deposit \$${widget.contract.amount.toStringAsFixed(0)} in Escrow',
                            isLoading: state.status == ContractsStatus.approving,
                            showIcon: false,
                            onTap: () {
                              context.read<ContractsBloc>().add(FundContract(widget.contract.id));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              // 3. Freelancer: Deliver Work
              if (!isClient && widget.contract.status == 'ACTIVE') ...[
                DeliveryUploadForm(contractId: widget.contract.id),
              ],

              // 4. Client: Review Work
              if (isClient && widget.contract.status == 'SUBMITTED') ...[
                ClientReviewCard(contract: widget.contract),
              ],
              
              // 5. Freelancer: Waiting for Review
              if (!isClient && widget.contract.status == 'SUBMITTED') ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Work Delivered!', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF065F46))),
                            const SizedBox(height: 4),
                            Text('Waiting for the client to review and approve your delivery.', style: AppTypography.caption.copyWith(color: const Color(0xFF047857))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 6. Leave Review for COMPLETED contracts
              if (widget.contract.status == 'COMPLETED') ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Leave a Review', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text('Share your experience working on this contract.', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _submissionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Share your experience...',
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<ContractsBloc, ContractsState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            label: 'Submit Review',
                            isLoading: state.status == ContractsStatus.approving,
                            showIcon: false,
                            onTap: () {
                              if (_submissionController.text.trim().isEmpty) return;
                              
                              final revieweeId = isClient ? widget.contract.freelancerId : widget.contract.clientId;
                              
                              context.read<ContractsBloc>().add(LeaveReview(
                                contractId: widget.contract.id,
                                revieweeId: revieweeId,
                                rating: 5,
                                comment: _submissionController.text,
                              ));
                              _submissionController.clear();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
