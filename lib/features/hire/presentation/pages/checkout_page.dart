import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/hire_bloc.dart';
import '../bloc/hire_event.dart';
import '../bloc/hire_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HireBloc, HireState>(
      listener: (context, state) {
        if (state.status == HireStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Payment failed', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
          );
        } else if (state.status == HireStatus.paymentSuccess) {
          context.go('/payment_success');
        }
      },
      builder: (context, state) {
        if (state.contractId == null) {
          return const Scaffold(body: Center(child: Text('No contract found', style: TextStyle(color: Color(0xFF111827)))));
        }

        final subtotal = state.proposal?.bidAmount ?? state.directAmount;

        if (subtotal == null) {
          return const Scaffold(body: Center(child: Text('Invalid contract amount', style: TextStyle(color: Color(0xFF111827)))));
        }

        final fee = subtotal * 0.05; // 5% marketplace fee
        final total = subtotal + fee;

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Checkout',
              style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827)),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary Label
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Order Summary',
                        style: AppTypography.headingSmall.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Order Summary Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow('Subtotal', subtotal),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Marketplace Fee (5%)', fee),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Color(0xFFE5E7EB), height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Payment', style: AppTypography.headingSmall.copyWith(color: const Color(0xFF111827))),
                              Text('\$${total.toStringAsFixed(2)}', style: AppTypography.headingMedium.copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Payment Method Label
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Payment Method',
                        style: AppTypography.headingSmall.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Payment Method Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.credit_card_rounded, color: Color(0xFF374151), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Stripe Secure Checkout', style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('Credit Card, Apple Pay, Google Pay', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    // Escrow Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock_outline_rounded, color: Color(0xFF2563EB), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Secure Escrow Payment',
                                  style: AppTypography.labelLarge.copyWith(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Funds are held securely by Axon Intelligence and are only released when you approve the delivered work.',
                                  style: AppTypography.caption.copyWith(color: const Color(0xFF1E40AF), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Pay Button
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
                  child: PrimaryButton(
                    label: 'Pay \$${total.toStringAsFixed(2)} Securely',
                    isLoading: state.status == HireStatus.paymentProcessing,
                    showIcon: true,
                    icon: Icons.open_in_new_rounded,
                    onTap: () {
                      context.read<HireBloc>().add(const HireProcessPayment());
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563), fontSize: 16)),
        Text('\$${amount.toStringAsFixed(2)}', style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
