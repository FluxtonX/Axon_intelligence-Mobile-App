import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/models/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        UserModel? user;
        if (state is ProfileLoaded) {
          user = state.user;
        }
        
        final bool isGuest = user == null;
        final avatarUrl = user?.profile?.avatarUrl;
        final firstName = user?.profile?.firstName ?? 'Guest';
        final lastName = user?.profile?.lastName ?? '';
        final displayName = isGuest ? 'Guest User' : '$firstName $lastName'.trim();

        String finalAvatarUrl = 'https://ui-avatars.com/api/?name=U&background=3B6EF5&color=fff';
        if (!isGuest) {
          if (avatarUrl != null && avatarUrl.isNotEmpty) {
            finalAvatarUrl = avatarUrl;
          } else {
            final name = user?.profile != null ? '${user!.profile!.firstName} ${user.profile!.lastName}'.trim() : 'U';
            finalAvatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name.isEmpty ? 'U' : name)}&background=3B6EF5&color=fff';
          }
        }

        return Row(
      children: [
        // Profile Picture directly navigating to Settings
        GestureDetector(
          onTap: () {
            context.push('/settings');
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isGuest ? const Color(0xFFF3F4F6) : Colors.transparent,
              image: !isGuest ? DecorationImage(
                image: NetworkImage(finalAvatarUrl),
                fit: BoxFit.cover,
              ) : null,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            ),
            child: isGuest
                ? const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        // Greeting & Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                displayName,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        // Notification Bell
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3F4F6), // Light gray background
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textDark,
                size: 24,
              ),
            ),
            // Notification Badge (Red dot)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
      },
    );
  }
}
