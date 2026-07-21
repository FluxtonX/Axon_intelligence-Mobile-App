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
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submit Proposal',
                  style: AppTypography.headingSmall.copyWith(color: AppColors.textPrimary),
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
                      style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bidAmountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Bid Amount (\$)',
                              hintText: 'e.g. 500',
                              labelStyle: const TextStyle(color: AppColors.textSecondary),
                              hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
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
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Delivery (Days)',
                              hintText: 'e.g. 7',
                              labelStyle: const TextStyle(color: AppColors.textSecondary),
                              hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.timer_outlined, color: AppColors.primary),
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
                      style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _coverLetterController,
                      maxLines: 8,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Explain why you are the best fit for this project...',
                        hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
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
              color: AppColors.background,
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
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
