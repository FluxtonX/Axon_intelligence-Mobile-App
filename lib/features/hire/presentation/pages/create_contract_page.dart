import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/hire_bloc.dart';
import '../bloc/hire_event.dart';
import '../bloc/hire_state.dart';

import '../../../proposals/domain/entities/proposal_entity.dart';

class CreateContractPage extends StatefulWidget {
  final ProposalEntity proposal;

  const CreateContractPage({
    super.key,
    required this.proposal,
  });

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  final _titleController = TextEditingController();
  final _milestoneTitleController = TextEditingController();
  final _milestoneAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HireBloc>().add(
          HireInitialize(
            proposal: widget.proposal,
          ),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _milestoneTitleController.dispose();
    _milestoneAmountController.dispose();
    super.dispose();
  }

  void _acceptProposal() {
    context.read<HireBloc>().add(const HireAcceptProposal());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HireBloc, HireState>(
      listener: (context, state) {
        if (state.status == HireStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        } else if (state.status == HireStatus.contractCreated) {
          // Navigate to checkout
          context.push('/checkout');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Hire ${widget.proposal.freelancerName}',
              style: AppTypography.headingMedium.copyWith(fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Title',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g. E-commerce App Redesign',
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    // Fixed Price Summary
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Proposal Fixed Bid', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            '\$${widget.proposal.bidAmount.toStringAsFixed(2)}',
                            style: AppTypography.headingLarge.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(height: 16),
                          Text('Delivery Time: ${widget.proposal.estimatedDays} days', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Total and Continue Button
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total Price', style: AppTypography.caption),
                          Text(
                            '\$${widget.proposal.bidAmount.toStringAsFixed(2)}',
                            style: AppTypography.headingMedium.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Accept & Pay',
                          isLoading: state.status == HireStatus.loading,
                          showIcon: false,
                          onTap: _acceptProposal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
