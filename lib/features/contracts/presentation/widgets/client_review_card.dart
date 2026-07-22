import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';
import '../../domain/entities/contract_entity.dart';

class ClientReviewCard extends StatelessWidget {
  final ContractEntity contract;

  const ClientReviewCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping_rounded, color: Color(0xFFEF4444), size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Work Delivered', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
                  Text(
                    'Review the files before approving.',
                    style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Delivery Details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Freelancer\'s Message:', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  contract.status == 'SUBMITTED' ? 'Here is the final delivery as requested! Let me know if you need any adjustments.' : 'Delivery approved.',
                  style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563), fontStyle: FontStyle.italic),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Color(0xFFE5E7EB)),
                ),
                Row(
                  children: [
                    const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('deliverable.zip', style: AppTypography.labelLarge),
                    ),
                    const Icon(Icons.download_rounded, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          BlocBuilder<ContractsBloc, ContractsState>(
            builder: (context, state) {
              return Column(
                children: [
                  PrimaryButton(
                    label: 'Approve & Release \$${contract.amount.toStringAsFixed(0)}',
                    isLoading: state.status == ContractsStatus.approving,
                    showIcon: false,
                    onTap: () {
                      context.read<ContractsBloc>().add(ApproveWork(contract.id));
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Request revision (not fully implemented in backend yet, so just show a snackbar)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Revision request sent in messages.')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Request Revision',
                        style: AppTypography.labelLarge.copyWith(color: const Color(0xFF4B5563), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
