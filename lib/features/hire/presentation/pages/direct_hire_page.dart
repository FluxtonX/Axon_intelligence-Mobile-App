import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/hire_bloc.dart';
import '../bloc/hire_event.dart';
import '../bloc/hire_state.dart';
import '../../../../shared/widgets/auth_guard_dialog.dart';

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

    AuthGuard.requireAuth(
      context,
      title: 'Sign in to Hire',
      subtitle: 'You need an account to securely hire freelancers and deposit funds into escrow.',
      onAuthenticated: () {
        context.read<HireBloc>().add(HireCreateDirectContract(
              freelancerId: widget.freelancerId,
              title: title,
              description: description,
              amount: amount,
              deliveryDays: days,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HireBloc, HireState>(
      listener: (context, state) {
        if (state.status == HireStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
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
              style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827)),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.handshake_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Secure Escrow Contract', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
                            const SizedBox(height: 4),
                            Text('Funds are held securely until you approve the final work.', style: AppTypography.caption.copyWith(color: const Color(0xFF4B5563))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                _buildLabel('Project Title'),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                  decoration: _inputDecoration(
                    hint: 'e.g. Build a Custom Logo',
                    icon: Icons.title_rounded,
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildLabel('Requirements'),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                  decoration: _inputDecoration(
                    hint: 'Describe exactly what you need delivered...',
                    icon: Icons.description_outlined,
                  ).copyWith(alignLabelWithHint: true),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Budget'),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.bold),
                            decoration: _inputDecoration(
                              hint: '500',
                              icon: Icons.attach_money_rounded,
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
                          _buildLabel('Delivery Time'),
                          TextFormField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.bold),
                            decoration: _inputDecoration(
                              hint: '7',
                              icon: Icons.calendar_today_rounded,
                              suffix: 'Days',
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
                  showIcon: true,
                  icon: Icons.lock_outline_rounded,
                  onTap: _createOffer,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Protected by Axon Escrow',
                      style: AppTypography.caption.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF374151)),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, String? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.normal),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
