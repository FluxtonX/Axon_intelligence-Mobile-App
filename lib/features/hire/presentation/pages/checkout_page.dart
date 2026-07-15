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
            SnackBar(content: Text(state.errorMessage ?? 'Payment failed')),
          );
        } else if (state.status == HireStatus.paymentSuccess) {
          context.go('/payment_success');
        }
      },
      builder: (context, state) {
        if (state.contract == null) {
          return const Scaffold(body: Center(child: Text('No contract found')));
        }

        final subtotal = state.totalAmount;
        final fee = subtotal * 0.05; // 5% marketplace fee
        final total = subtotal + fee;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9FAFB),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Checkout',
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
                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Summary', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal', style: AppTypography.bodyMedium),
                              Text('\$${subtotal.toStringAsFixed(2)}', style: AppTypography.labelLarge),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Marketplace Fee (5%)', style: AppTypography.bodyMedium),
                              Text('\$${fee.toStringAsFixed(2)}', style: AppTypography.labelLarge),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: Color(0xFFE5E7EB)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                              Text('\$${total.toStringAsFixed(2)}', style: AppTypography.headingMedium.copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Payment Method (Mock)
                    Text('Payment Method', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card, color: Color(0xFF4B5563)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('•••• •••• •••• 4242', style: AppTypography.labelLarge),
                              Text('Expires 12/26', style: AppTypography.caption),
                            ],
                          ),
                          const Spacer(),
                          Icon(Icons.check_circle_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    // Escrow Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.security, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your payment is held securely in escrow until you approve the delivered work.',
                              style: AppTypography.caption.copyWith(color: const Color(0xFF1D4ED8)),
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
                    label: 'Pay \$${total.toStringAsFixed(2)}',
                    isLoading: state.status == HireStatus.paymentProcessing,
                    showIcon: false,
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
}
