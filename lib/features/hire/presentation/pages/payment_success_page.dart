import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../contracts/data/repositories/contract_repository.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String? contractId;
  const PaymentSuccessPage({super.key, this.contractId});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool _isLoading = false;

  void _viewOrderDetails() async {
    if (widget.contractId == null) {
      context.go('/home');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = context.read<ContractRepository>();
      final contract = await repo.getContractById(widget.contractId!);
      if (!mounted) return;
      context.go('/contract-detail', extra: {'contract': contract});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load contract details: $e')),
      );
      context.go('/home');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon Animation placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Payment Successful!',
                style: AppTypography.headingLarge.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your contract has been created and funds are securely held in escrow. The freelancer has been notified.',
                style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'View Order Details',
                isLoading: _isLoading,
                showIcon: false,
                onTap: _viewOrderDetails,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(
                  'Back to Home',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
