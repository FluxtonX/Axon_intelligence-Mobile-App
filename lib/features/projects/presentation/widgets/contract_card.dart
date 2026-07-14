import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
    required this.title,
    required this.freelancerName,
    required this.avatarUrl,
    required this.status,
    required this.escrowAmount,
    required this.progress,
    this.isActive = true,
  });

  final String title;
  final String freelancerName;
  final String avatarUrl;
  final String status;
  final double escrowAmount;
  final double progress;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
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
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headingSmall.copyWith(
                    color: const Color(0xFF111827),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive 
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'Active' : 'Completed',
                  style: AppTypography.caption.copyWith(
                    color: isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Freelancer Info
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
              const SizedBox(width: 8),
              Text(
                freelancerName,
                style: AppTypography.labelMedium.copyWith(color: const Color(0xFF4B5563)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Escrow & Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'In Escrow',
                    style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${escrowAmount.toStringAsFixed(2)}',
                    style: AppTypography.labelLarge.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status,
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF374151),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF3F4F6),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isActive ? AppColors.primary : const Color(0xFF10B981),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
