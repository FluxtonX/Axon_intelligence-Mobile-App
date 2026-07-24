import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import '../bloc/seller_onboarding_bloc.dart';
import '../bloc/seller_onboarding_event.dart';
import '../bloc/seller_onboarding_state.dart';

class BecomeFreelancerPage extends StatelessWidget {
  const BecomeFreelancerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SellerOnboardingBloc(
        RepositoryProvider.of<ProfileRepository>(context),
      ),
      child: const _BecomeFreelancerView(),
    );
  }
}

class _BecomeFreelancerView extends StatefulWidget {
  const _BecomeFreelancerView();

  @override
  State<_BecomeFreelancerView> createState() => _BecomeFreelancerViewState();
}

class _BecomeFreelancerViewState extends State<_BecomeFreelancerView> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  final _titleController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _bioController = TextEditingController();
  List<String> _skills = [];

  final _skillInputController = TextEditingController();

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final rateText = _hourlyRateController.text.trim();
    final bio = _bioController.text.trim();
    
    if (title.isEmpty || rateText.isEmpty || bio.isEmpty || _skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    final hourlyRate = double.tryParse(rateText) ?? 20.0;

    context.read<SellerOnboardingBloc>().add(SubmitSellerProfile(
      title: title,
      bio: bio,
      skills: _skills,
      hourlyRate: hourlyRate,
    ));
  }

  void _addSkill() {
    final skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
      });
      _skillInputController.clear();
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellerOnboardingBloc, SellerOnboardingState>(
      listener: (context, state) {
        if (state is SellerOnboardingSuccess) {
          // Switch to freelancer mode!
          context.read<UserModeCubit>().toggleMode(); // Ensure they are freelancer
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text('Welcome to Axon!', style: AppTypography.headingMedium),
                  const SizedBox(height: 8),
                  const Text('Your freelancer profile is now live.', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Go to Dashboard',
                    onTap: () {
                      context.pop(); // close dialog
                      context.pop(); // close page
                      // Normally this redirects to dashboard but UserModeCubit does it via main shell
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is SellerOnboardingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
            onPressed: _previousStep,
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: _currentStep >= index ? AppColors.primary : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildWelcomeStep(),
              _buildProfessionalStep(),
              _buildSkillsStep(),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: BlocBuilder<SellerOnboardingBloc, SellerOnboardingState>(
              builder: (context, state) {
                return PrimaryButton(
                  label: _currentStep == 2 ? 'Complete Profile' : 'Continue',
                  isLoading: state is SellerOnboardingLoading,
                  showIcon: _currentStep != 2,
                  icon: Icons.arrow_forward_rounded,
                  onTap: _nextStep,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to start earning?',
            style: AppTypography.headingMedium.copyWith(fontSize: 28, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          Text(
            'Join the Axon Intelligence marketplace and connect with clients looking for your expertise. Setup only takes 2 minutes.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your profile will be instantly approved during this beta phase.',
                    style: AppTypography.caption.copyWith(color: AppColors.textDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Details',
            style: AppTypography.headingMedium.copyWith(fontSize: 24, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell clients what you do and how much you charge.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Text('Professional Headline', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'e.g., Senior UI/UX Designer',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            ),
          ),
          const SizedBox(height: 24),
          Text('Hourly Rate (\$)', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _hourlyRateController,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'e.g., 50',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Bio',
            style: AppTypography.headingMedium.copyWith(fontSize: 24, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Highlight your expertise.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Text('Your Skills', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillInputController,
                  style: const TextStyle(color: Colors.black),
                  onSubmitted: (_) => _addSkill(),
                  decoration: InputDecoration(
                    hintText: 'e.g., Flutter, Figma, Python',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _addSkill,
                icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 36),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skills.map((skill) {
              return Chip(
                label: Text(skill, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.primary),
                onDeleted: () => _removeSkill(skill),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.transparent)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Brief Bio', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 4,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Tell clients a bit about yourself...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            ),
          ),
        ],
      ),
    );
  }
}
