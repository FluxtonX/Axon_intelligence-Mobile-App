import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'primary_button.dart';

class AuthGuard {
  /// Checks if the user is authenticated.
  /// If authenticated, executes [onAuthenticated].
  /// If guest/unauthenticated, shows the Auth Prompt Bottom Sheet.
  static void requireAuth(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String title = 'Sign in required',
    String subtitle = 'Please sign in or create an account to access this feature.',
  }) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    final authBloc = context.read<AuthBloc>();
    final isGuest = authBloc.state is AuthGuestMode || !authRepo.isLoggedIn();

    if (!isGuest) {
      onAuthenticated();
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (dialogContext) => _AuthPromptBottomSheet(
          title: title,
          subtitle: subtitle,
        ),
      );
    }
  }
}

class _AuthPromptBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AuthPromptBottomSheet({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161B26),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTypography.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Sign In / Register',
            onTap: () {
              Navigator.pop(context);
              context.go('/auth');
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue as Guest',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
