import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';

class SubmitProposalPage extends StatefulWidget {
  final String jobTitle;
  final String clientName;

  const SubmitProposalPage({
    super.key,
    required this.jobTitle,
    required this.clientName,
  });

  @override
  State<SubmitProposalPage> createState() => _SubmitProposalPageState();
}

class _SubmitProposalPageState extends State<SubmitProposalPage> {
  final _bidController = TextEditingController();
  final _daysController = TextEditingController();
  final _letterController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bidController.dispose();
    _daysController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Proposal submitted successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Pop back to Find Work page
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Submit Proposal', style: AppTypography.headingSmall.copyWith(fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Details', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                    const SizedBox(height: 8),
                    Text(widget.jobTitle, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.clientName, style: AppTypography.caption),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bid Amount
              Text('Your Bid (\$)', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _bidController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 500',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF6B7280)),
                ),
              ),
              const SizedBox(height: 24),

              // Delivery Time
              Text('Delivery Time (Days)', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _daysController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 14',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF6B7280), size: 20),
                ),
              ),
              const SizedBox(height: 24),

              // Cover Letter
              Text('Cover Letter', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _letterController,
                style: const TextStyle(color: Colors.black),
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Why are you the best fit for this project? Provide links to past work...',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              PrimaryButton(
                label: 'Send Proposal',
                showIcon: false,
                isLoading: _isSubmitting,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
