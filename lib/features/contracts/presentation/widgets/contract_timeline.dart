import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ContractTimeline extends StatelessWidget {
  final String status;
  final DateTime createdAt;

  const ContractTimeline({
    super.key,
    required this.status,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    // Map status to current step index
    int currentStep = 0;
    if (status == 'PENDING' || status == 'PENDING_PAYMENT') {
      currentStep = 0;
    } else if (status == 'ACTIVE') {
      currentStep = 1;
    } else if (status == 'SUBMITTED') {
      currentStep = 2;
    } else if (status == 'COMPLETED') {
      currentStep = 3;
    }

    final steps = [
      {'title': 'Order Placed', 'subtitle': _formatDate(createdAt)},
      {'title': 'Requirements & Escrow', 'subtitle': currentStep >= 1 ? 'Funded' : 'Pending'},
      {'title': 'Delivery', 'subtitle': currentStep >= 2 ? 'Submitted' : 'In Progress'},
      {'title': 'Completed', 'subtitle': currentStep >= 3 ? 'Approved' : 'Pending'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Progress', style: AppTypography.headingSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 24),
          ...List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? const Color(0xFF10B981) 
                            : isCurrent ? AppColors.primary : Colors.white,
                        border: Border.all(
                          color: isCompleted 
                              ? const Color(0xFF10B981) 
                              : isCurrent ? AppColors.primary : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : isCurrent 
                              ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))
                              : null,
                    ),
                    if (index < steps.length - 1)
                      Container(
                        width: 2,
                        height: 30,
                        color: isCompleted ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index]['title']!,
                        style: AppTypography.labelLarge.copyWith(
                          color: isCompleted || isCurrent ? AppColors.textDark : const Color(0xFF9CA3AF),
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index]['subtitle']!,
                        style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
                      ),
                      if (index < steps.length - 1) const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
