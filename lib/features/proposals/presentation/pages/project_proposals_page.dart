import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/models/project_model.dart';
import '../../domain/entities/proposal_entity.dart';
import '../../data/repositories/proposal_repository.dart';

class ProjectProposalsPage extends StatefulWidget {
  final ProjectModel project;

  const ProjectProposalsPage({super.key, required this.project});

  @override
  State<ProjectProposalsPage> createState() => _ProjectProposalsPageState();
}

class _ProjectProposalsPageState extends State<ProjectProposalsPage> {
  bool _isLoading = true;
  String? _error;
  List<ProposalEntity> _proposals = [];

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    try {
      final repository = context.read<ProposalRepository>();
      final proposals = await repository.getProposalsForProject(widget.project.id);
      if (mounted) {
        setState(() {
          _proposals = proposals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptProposal(String proposalId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final repository = context.read<ProposalRepository>();
      final contractId = await repository.acceptProposal(proposalId);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal accepted! Contract generated.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        
        // Navigate back and maybe to contract details
        context.pop(); 
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Proposals',
          style: AppTypography.headingSmall.copyWith(
            color: const Color(0xFF111827),
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.title,
                    style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Budget: \$${widget.project.budget.toStringAsFixed(0)}',
                    style: AppTypography.labelLarge.copyWith(color: const Color(0xFF10B981)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : _proposals.isEmpty
                          ? const Center(child: Text('No proposals yet.'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(24),
                              itemCount: _proposals.length,
                              itemBuilder: (context, index) {
                                final proposal = _proposals[index];
                                return _buildProposalCard(proposal);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalCard(ProposalEntity proposal) {
    final freelancerName = proposal.freelancer?['profile']?['firstName'] ?? 'Freelancer';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    freelancerName,
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${proposal.bidAmount.toStringAsFixed(0)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Cover Letter',
            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            proposal.coverLetter,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                '${proposal.deliveryDays} days delivery',
                style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: proposal.status == 'PENDING' ? () => _acceptProposal(proposal.id) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              proposal.status == 'ACCEPTED' ? 'Accepted' : 'Accept Proposal',
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
