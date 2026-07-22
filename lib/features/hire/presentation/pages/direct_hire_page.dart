import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/hire_bloc.dart';
import '../bloc/hire_event.dart';
import '../bloc/hire_state.dart';

class DirectHirePage extends StatefulWidget {
  final String freelancerId;
  final String freelancerName;

  const DirectHirePage({
    super.key,
    required this.freelancerId,
    required this.freelancerName,
  });

  @override
  State<DirectHirePage> createState() => _DirectHirePageState();
}

class _DirectHirePageState extends State<DirectHirePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _daysController = TextEditingController(text: '7');

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _createOffer() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final amountText = _amountController.text.trim();
    final daysText = _daysController.text.trim();

    if (title.isEmpty || description.isEmpty || amountText.isEmpty || daysText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    final days = int.tryParse(daysText);

    if (amount == null || amount <= 0 || days == null || days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers for amount and days')),
      );
      return;
    }

    context.read<HireBloc>().add(HireCreateDirectContract(
          freelancerId: widget.freelancerId,
          title: title,
          description: description,
          amount: amount,
          deliveryDays: days,
        ));
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
              icon: const Icon(Icons.close_rounded, color: Color(0xFF111827)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Offer for ${widget.freelancerName}',
              style: AppTypography.headingMedium.copyWith(fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                  style: const TextStyle(color: Color(0xFF111827)),
                  decoration: InputDecoration(
                    hintText: 'e.g. Build a Custom Logo',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Requirements',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: Color(0xFF111827)),
                  decoration: InputDecoration(
                    hintText: 'Describe exactly what you need delivered...',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget (\$)',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF111827)),
                            decoration: InputDecoration(
                              hintText: '500',
                              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Time (Days)',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF111827)),
                            decoration: InputDecoration(
                              hintText: '7',
                              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  label: 'Send Offer & Deposit Funds',
                  isLoading: state.status == HireStatus.loading,
                  showIcon: false,
                  onTap: _createOffer,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Your funds will be held securely in Escrow.',
                    style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
