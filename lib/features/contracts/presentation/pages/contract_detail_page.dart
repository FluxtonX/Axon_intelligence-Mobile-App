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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.contract.status,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Amount in Escrow', style: AppTypography.labelLarge.copyWith(color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(
                '\$${widget.contract.amount.toStringAsFixed(2)}',
                style: AppTypography.headingLarge.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 32),

              // Client: Fund Contract
              if (isClient && (widget.contract.status == 'PENDING_PAYMENT' || widget.contract.status == 'PENDING')) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fund Contract', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text(
                        'Fund this contract to move it to ACTIVE status and let the freelancer start working. Funds will be held securely in escrow.',
                        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ContractsBloc, ContractsState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Fund Contract',
                      isLoading: state.status == ContractsStatus.approving, // reusing approving status for loading
                      showIcon: false,
                      onTap: () {
                        context.read<ContractsBloc>().add(FundContract(widget.contract.id));
                      },
                    );
                  },
                ),
              ],

              // Freelancer: Submit Work
              if (!isClient && widget.contract.status == 'ACTIVE') ...[
                Text('Submit Work', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                const SizedBox(height: 12),
                TextField(
                  controller: _submissionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter link to work (GitHub, Figma, Drive) or details...',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ContractsBloc, ContractsState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Submit for Review',
                      isLoading: state.status == ContractsStatus.submitting,
                      showIcon: false,
                      onTap: () {
                        if (_submissionController.text.trim().isEmpty) return;
                        context.read<ContractsBloc>().add(SubmitWork(
                          contractId: widget.contract.id,
                          submissionDetails: _submissionController.text,
                        ));
                      },
                    );
                  },
                ),
              ],

              // Client: Review Work
              if (isClient && widget.contract.status == 'SUBMITTED') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Work Submitted!', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text(
                        'The freelancer has submitted the work for your review. Please review the submission and release the funds if it meets your requirements.',
                        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ContractsBloc, ContractsState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Approve & Release Funds',
                      isLoading: state.status == ContractsStatus.approving,
                      showIcon: false,
                      onTap: () {
                        context.read<ContractsBloc>().add(ApproveWork(widget.contract.id));
                      },
                    );
                  },
                ),
              ],

              // Leave Review for COMPLETED contracts
              if (widget.contract.status == 'COMPLETED') ...[
                const SizedBox(height: 16),
                Text('Leave a Review', style: AppTypography.headingSmall.copyWith(color: AppColors.textDark)),
                const SizedBox(height: 12),
                TextField(
                  controller: _submissionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Share your experience working with them...',
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
                      isLoading: state.status == ContractsStatus.approving, // reusing status for now
                      showIcon: false,
                      onTap: () {
                        if (_submissionController.text.trim().isEmpty) return;
                        
                        final revieweeId = isClient ? widget.contract.freelancerId : widget.contract.clientId;
                        
                        context.read<ContractsBloc>().add(LeaveReview(
                          contractId: widget.contract.id,
                          revieweeId: revieweeId,
                          rating: 5, // Simple mock rating
                          comment: _submissionController.text,
                        ));
                        _submissionController.clear();
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
