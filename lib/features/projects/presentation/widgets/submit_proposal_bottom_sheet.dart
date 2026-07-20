import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/models/project_model.dart';
import '../../../proposals/data/repositories/proposal_repository.dart';
import 'package:go_router/go_router.dart';

class SubmitProposalBottomSheet extends StatefulWidget {
  final ProjectModel project;

  const SubmitProposalBottomSheet({super.key, required this.project});

  @override
  State<SubmitProposalBottomSheet> createState() => _SubmitProposalBottomSheetState();
}

class _SubmitProposalBottomSheetState extends State<SubmitProposalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bidAmountController = TextEditingController();
  final _deliveryDaysController = TextEditingController();
  final _coverLetterController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _bidAmountController.text = widget.project.budget.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _deliveryDaysController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _submitProposal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = context.read<ProposalRepository>();
      await repository.submitProposal(
        projectId: widget.project.id,
        bidAmount: double.parse(_bidAmountController.text),
        deliveryDays: int.parse(_deliveryDaysController.text),
        coverLetter: _coverLetterController.text,
      );

      if (mounted) {
        context.pop(); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal submitted successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submit Proposal',
                  style: AppTypography.headingSmall.copyWith(color: AppColors.textDark),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bid Details',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bidAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Bid Amount (\$)',
                              hintText: 'e.g. 500',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              prefixIcon: const Icon(Icons.attach_money_rounded),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (double.tryParse(v) == null) return 'Invalid number';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _deliveryDaysController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Delivery (Days)',
                              hintText: 'e.g. 7',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              prefixIcon: const Icon(Icons.timer_outlined),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null) return 'Invalid number';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Cover Letter',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _coverLetterController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Explain why you are the best fit for this project...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Submit Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitProposal,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Submit Proposal',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
