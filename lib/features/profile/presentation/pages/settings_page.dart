import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          'Settings',
          style: AppTypography.headingSmall.copyWith(color: AppColors.textDark),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsItem(
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            onTap: () {
              context.push('/edit_profile');
            },
          ),
          _buildSettingsItem(
            icon: Icons.payment_rounded,
            title: 'Payment Methods',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Freelancer'),
          BlocBuilder<UserModeCubit, UserMode>(
            builder: (context, mode) {
              final isFreelancer = mode == UserMode.freelancer;
              return _buildSettingsItem(
                icon: Icons.work_outline_rounded,
                title: isFreelancer ? 'Switch to Buyer Mode' : 'Become a Freelancer',
                onTap: () {
                  if (isFreelancer) {
                    context.read<UserModeCubit>().setMode(UserMode.client);
                  } else {
                    context.push('/seller_onboarding');
                  }
                },
              );
            },
          ),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Preferences'),
          _buildSettingsItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            trailing: const Text('Light'),
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: const Text('English (US)'),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Security'),
          _buildSettingsItem(
            icon: Icons.lock_outline_rounded,
            title: 'Password & Security',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Authentication',
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: AppColors.primary,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          
          // Sign Out Button
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: Text('Sign Out', style: AppTypography.bodyMedium.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              onTap: () {
                context.read<AuthBloc>().add(const SignOutRequested());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTypography.headingSmall.copyWith(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textDark),
        title: Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
