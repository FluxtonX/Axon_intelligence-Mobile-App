import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../projects/presentation/bloc/client_projects_bloc.dart';
import '../../../projects/presentation/bloc/client_projects_state.dart';

class ProjectBriefReviewPage extends StatefulWidget {
  const ProjectBriefReviewPage({super.key});

  @override
  State<ProjectBriefReviewPage> createState() => _ProjectBriefReviewPageState();
}

class _ProjectBriefReviewPageState extends State<ProjectBriefReviewPage> {
  final TextEditingController _titleController = TextEditingController(text: 'E-Commerce Mobile App (Flutter & Firebase)');
  final TextEditingController _descriptionController = TextEditingController(
      text: 'I am looking for an experienced Flutter developer to build a modern e-commerce mobile application. The app should have a sleek, premium UI/UX, user authentication via Firebase, product catalog, shopping cart, and Stripe integration for payments. The ideal candidate has experience with state management (Bloc/Provider) and building scalable architectures.\n\nKey Requirements:\n- Flutter (iOS & Android)\n- Firebase Authentication & Firestore\n- Stripe Payment Integration\n- Push Notifications\n- Clean Architecture');
  final TextEditingController _budgetController = TextEditingController(text: '2000');
  final TextEditingController _timelineController = TextEditingController(text: '2 - 4 Weeks');
  final TextEditingController _skillsController = TextEditingController(text: 'Flutter, Firebase, Stripe API');

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _timelineController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Review Project Brief',
          style: AppTypography.headingSmall.copyWith(fontSize: 16, color: AppColors.textDark),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ClientProjectsBloc, ClientProjectsState>(
        listener: (context, state) {
          if (state.publishStatus == PublishStatus.success) {
            context.read<ClientProjectsBloc>().add(ResetPublishStatusEvent());
            context.go('/home');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your job has been published successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.publishStatus == PublishStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.publishError ?? 'Failed to publish job'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'AI Generated',
                    style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Title Input
            Text(
              'Project Title',
              style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _titleController,
                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description Input
            Text(
              'Project Description',
              style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _descriptionController,
                style: AppTypography.bodyMedium.copyWith(height: 1.6),
                maxLines: 12,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Skills Input
            Text(
              'Required Skills (comma separated)',
              style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _skillsController,
                style: AppTypography.bodyMedium,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'e.g. Flutter, Firebase, Node.js',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Budget and Timeline Inputs
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget (\$)',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          style: AppTypography.bodyMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timeline',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: _timelineController,
                          style: AppTypography.bodyMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Save Draft',
                    onPressed: () {
                      context.go('/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Project saved as draft!')),
                      );
                    },
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    label: state.publishStatus == PublishStatus.loading ? 'Publishing...' : 'Publish Job',
                    onPressed: state.publishStatus == PublishStatus.loading ? null : () {
                      final double parsedBudget = double.tryParse(_budgetController.text) ?? 0.0;
                      final List<String> parsedSkills = _skillsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList();

                      context.read<ClientProjectsBloc>().add(
                        PublishProjectEvent(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          budget: parsedBudget,
                          timeline: _timelineController.text,
                          skills: parsedSkills,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    },
  ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: const Color(0xFF4B5563), fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEstimateCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.labelLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
