import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/models/project_model.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../widgets/submit_proposal_bottom_sheet.dart';
import 'edit_project_page.dart';
import '../../../proposals/presentation/pages/project_proposals_page.dart';
import '../bloc/client_projects_state.dart';
import '../bloc/client_projects_bloc.dart';
import '../../../../shared/widgets/auth_guard_dialog.dart';
class ProjectDetailsPage extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  late ProjectModel project;

  @override
  void initState() {
    super.initState();
    project = widget.project;
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
          'Project Details',
          style: AppTypography.headingSmall.copyWith(
            color: const Color(0xFF111827),
            fontSize: 18,
          ),
        ),
        actions: [
          BlocBuilder<UserModeCubit, UserMode>(
            builder: (context, userMode) {
              if (userMode == UserMode.client) {
                return IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () async {
                    final updatedProject = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProjectPage(project: project),
                      ),
                    );
                    if (updatedProject != null && updatedProject is ProjectModel) {
                      setState(() {
                        project = updatedProject;
                      });
                      context.read<ClientProjectsBloc>().add(LoadClientProjectsEvent());
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.attach_money_rounded, size: 20, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Text(
                          '${project.budget.toStringAsFixed(0)} Budget',
                          style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827)),
                        ),
                        const SizedBox(width: 24),
                        const Icon(Icons.access_time_rounded, size: 20, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(
                          project.timeline ?? 'Flexible timeline',
                          style: AppTypography.labelLarge.copyWith(color: const Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Project Description',
                      style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      project.description,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Skills Required',
                      style: AppTypography.labelLarge.copyWith(color: const Color(0xFF111827), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            skill,
                            style: AppTypography.labelMedium.copyWith(color: const Color(0xFF4B5563)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            BlocBuilder<UserModeCubit, UserMode>(
              builder: (context, userMode) {
                if (userMode == UserMode.client) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectProposalsPage(project: project),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'View Proposals',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      AuthGuard.requireAuth(
                        context,
                        title: 'Sign in to Submit Proposal',
                        subtitle: 'You need a Freelancer account to apply to this project.',
                        onAuthenticated: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SubmitProposalBottomSheet(project: project),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(
                      'Submit Proposal',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
