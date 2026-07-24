import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/contracts_bloc.dart';
import '../bloc/contracts_event.dart';
import '../bloc/contracts_state.dart';

class DeliveryUploadForm extends StatefulWidget {
  final String contractId;

  const DeliveryUploadForm({super.key, required this.contractId});

  @override
  State<DeliveryUploadForm> createState() => _DeliveryUploadFormState();
}

class _DeliveryUploadFormState extends State<DeliveryUploadForm> {
  final _messageController = TextEditingController();
  XFile? _selectedFile;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final XFile? result = await openFile();
    if (result != null) {
      setState(() {
        _selectedFile = result;
      });
    }
  }

  Future<void> _deliverWork() async {
    if (_messageController.text.trim().isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a message or attach a file to deliver.')),
      );
      return;
    }

    final submissionText = _messageController.text.trim();
    final details = _selectedFile != null ? '[File Attached] $submissionText' : submissionText;

    List<int>? fileBytes;
    if (_selectedFile != null) {
      fileBytes = await _selectedFile!.readAsBytes();
    }

    if (!mounted) return;

    context.read<ContractsBloc>().add(SubmitWork(
      contractId: widget.contractId,
      submissionDetails: details,
      fileBytes: fileBytes,
      fileName: _selectedFile?.name,
    ));
  }

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
          Text('Deliver Your Work', style: AppTypography.headingMedium.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Upload the final files and add a message for the client.',
            style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          
          // File Upload Zone
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: _selectedFile != null ? const Color(0xFFF0FDF4) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedFile != null ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedFile != null ? Icons.task_rounded : Icons.cloud_upload_rounded,
                    size: 48,
                    color: _selectedFile != null ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFile != null ? _selectedFile!.name : 'Tap to upload files',
                    style: AppTypography.labelLarge.copyWith(
                      color: _selectedFile != null ? const Color(0xFF111827) : const Color(0xFF6B7280),
                      fontWeight: _selectedFile != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (_selectedFile == null) ...[
                    const SizedBox(height: 4),
                    Text('Max file size 1GB', style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF))),
                  ]
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text('Delivery Message', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 4,
            style: const TextStyle(color: Color(0xFF111827)),
            decoration: InputDecoration(
              hintText: 'Describe what you\'ve delivered...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          BlocBuilder<ContractsBloc, ContractsState>(
            builder: (context, state) {
              return PrimaryButton(
                label: 'Deliver Work',
                isLoading: state.status == ContractsStatus.submitting,
                showIcon: false,
                onTap: _deliverWork,
              );
            },
          ),
        ],
      ),
    );
  }
}
