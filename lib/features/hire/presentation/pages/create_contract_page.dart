import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/hire_bloc.dart';
import '../bloc/hire_event.dart';
import '../bloc/hire_state.dart';

class CreateContractPage extends StatefulWidget {
  final String freelancerId;
  final String freelancerName;

  const CreateContractPage({
    super.key,
    required this.freelancerId,
    required this.freelancerName,
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
            freelancerId: widget.freelancerId,
            freelancerName: widget.freelancerName,
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

  void _addMilestone() {
    if (_milestoneTitleController.text.isEmpty ||
        _milestoneAmountController.text.isEmpty) {
      return;
    }

    final amount = double.tryParse(_milestoneAmountController.text) ?? 0.0;
    if (amount <= 0) return;

    context.read<HireBloc>().add(HireAddMilestone(
          title: _milestoneTitleController.text,
          description: '',
          amount: amount,
        ));

    _milestoneTitleController.clear();
    _milestoneAmountController.clear();
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
              'Hire ${widget.freelancerName}',
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
                    const SizedBox(height: 32),
                    Text(
                      'Milestones',
                      style: AppTypography.headingMedium.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    
                    // List of current milestones
                    if (state.milestones.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          'No milestones added yet. Add your first milestone below.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.milestones.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final milestone = state.milestones[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        milestone.title,
                                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${milestone.amount.toStringAsFixed(2)}',
                                        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                                  onPressed: () => context.read<HireBloc>().add(HireRemoveMilestone(milestone.id)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                    
                    // Add new milestone form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Milestone',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _milestoneTitleController,
                            decoration: InputDecoration(
                              hintText: 'Task description',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _milestoneAmountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Amount (\$)',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: _addMilestone,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
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
                            '\$${state.totalAmount.toStringAsFixed(2)}',
                            style: AppTypography.headingMedium.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Continue to Pay',
                          isLoading: state.status == HireStatus.loading,
                          showIcon: false,
                          onTap: () {
                            context.read<HireBloc>().add(HireCreateContract(title: _titleController.text));
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
      },
    );
  }
}
