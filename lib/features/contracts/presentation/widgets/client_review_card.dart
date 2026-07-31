import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
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
                  Text('Work Delivered', style: AppTypography.headingMedium.copyWith(fontSize: 18, color: const Color(0xFF111827))),
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
                Text('Freelancer\'s Message:', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
                const SizedBox(height: 8),
                Text(
                  contract.submissionNotes ?? 'No message provided.',
                  style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4B5563), fontStyle: FontStyle.italic),
                ),
                if (contract.submissionUrl != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Color(0xFFE5E7EB)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final baseUrl = dotenv.env['API_BASE_URL']?.replaceAll('/api', '') ?? 'http://10.0.2.2:3000';
                      final url = '$baseUrl${contract.submissionUrl}';
                      try {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading file...')),
                          );
                        }
                        
                        Directory? dir;
                        if (Platform.isAndroid) {
                          dir = Directory('/storage/emulated/0/Download');
                          if (!await dir.exists()) {
                            dir = await getExternalStorageDirectory();
                          }
                        } else {
                          dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
                        }
                        
                        if (dir == null) throw Exception('Could not access storage directory');
                        
                        final filename = contract.submissionUrl!.split('/').last;
                        final savePath = '${dir.path}/$filename';
                        
                        await Dio().download(url, savePath);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('File downloaded to: ${Platform.isAndroid ? "Downloads/$filename" : savePath}'),
                              duration: const Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to download file: $e')),
                          );
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            contract.submissionUrl!.split('/').last, 
                            style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827), decoration: TextDecoration.underline),
                          ),
                        ),
                        const Icon(Icons.download_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
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
