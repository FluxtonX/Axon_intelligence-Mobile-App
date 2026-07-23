import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/email_auth_bloc.dart';
import '../bloc/email_auth_event.dart';
import '../bloc/email_auth_state.dart';
import '../../data/auth_repository.dart';
import '../../../../features/profile/presentation/bloc/profile_cubit.dart';

class EmailAuthPage extends StatelessWidget {
  const EmailAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailAuthBloc(context.read<AuthRepository>()),
      child: const _EmailAuthView(),
    );
  }
}

class _EmailAuthView extends StatefulWidget {
  const _EmailAuthView();

  @override
  State<_EmailAuthView> createState() => _EmailAuthViewState();
}

class _EmailAuthViewState extends State<_EmailAuthView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, bool isLogin) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
      context.read<EmailAuthBloc>().add(
            EmailAuthSubmitted(
              email: _emailController.text,
              password: _passwordController.text,
              name: isLogin ? null : _nameController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<EmailAuthBloc, EmailAuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.read<ProfileCubit>().loadProfile();
            context.go('/home');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully authenticated!')),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: const Color(0xFF10B981), // Green color for success
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: const Color(0xFFEF4444), // Red color for errors
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // ── Title ──────────────────────────────────────────
                    Text(
                      state.isLogin ? 'Welcome back' : 'Create an account',
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textDark,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.isLogin
                          ? 'Enter your details to sign in.'
                          : 'Sign up to start hiring or earning.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Full Name Field (Registration only) ────────────
                    AnimatedSize(
                      duration: AppConstants.animationFast,
                      child: !state.isLogin
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _AuthTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                hint: 'John Doe',
                                icon: Icons.person_outline_rounded,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (!state.isLogin && (value == null || value.trim().isEmpty)) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // ── Email Field ────────────────────────────────────
                    _AuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Password Field ─────────────────────────────────
                    _AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (!state.isLogin && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    // ── Forgot Password ────────────────────────────────
                    if (state.isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(context),
                          child: Text(
                            'Forgot Password?',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 24),

                    const SizedBox(height: 32),

                    // ── Submit Button ──────────────────────────────────
                    PrimaryButton(
                      label: state.isLogin ? 'Sign In' : 'Create Account',
                      isLoading: state.isLoading,
                      onTap: () => _submit(context, state.isLogin),
                      showIcon: false,
                    ),

                    const SizedBox(height: 24),

                    // ── Toggle Mode (Login <-> Register) ───────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _formKey.currentState?.reset();
                            context.read<EmailAuthBloc>().add(
                                  EmailAuthModeToggled(isLogin: !state.isLogin),
                                );
                          },
                          child: Text(
                            state.isLogin ? 'Sign Up' : 'Sign In',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final bloc = context.read<EmailAuthBloc>();
    final emailController = TextEditingController(text: _emailController.text);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Reset Password', style: AppTypography.headingMedium.copyWith(color: AppColors.textDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your email to receive a reset code.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'you@example.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                bloc.add(EmailAuthForgotPasswordSubmitted(email: emailController.text));
                Navigator.pop(dialogContext); // Close first dialog
                _showEnterResetCodeDialog(context); // Open second dialog immediately
              }
            },
            child: const Text('Send Reset Code'),
          ),
        ],
      ),
    );
  }

  void _showEnterResetCodeDialog(BuildContext context) {
    final bloc = context.read<EmailAuthBloc>();
    final codeController = TextEditingController();
    final newPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('Enter Reset Code', style: AppTypography.headingMedium.copyWith(color: AppColors.textDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('We sent a 6-digit code to your email.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: '000000',
                labelText: '6-Digit Code',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••••••',
                labelText: 'New Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (codeController.text.length == 6 && newPasswordController.text.length >= 6) {
                bloc.add(EmailAuthResetPasswordSubmitted(
                  token: codeController.text,
                  newPassword: newPasswordController.text,
                ));
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid 6-digit code and a password of at least 6 characters.')),
                );
              }
            },
            child: const Text('Save New Password'),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Text Field ──────────────────────────────────────────────────────
class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textDark),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
        ),
      ],
    );
  }
}
