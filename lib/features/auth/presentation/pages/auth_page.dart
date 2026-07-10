import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthGuestMode) {
          // TODO: context.go('/home');
        }
        if (state is AuthEmailFlowStarted) {
          context.push('/login/email');
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 52),

                // ── Logo ──────────────────────────────────────────────
                const _LogoSection(),

                const SizedBox(height: 48),

                // ── Headline ──────────────────────────────────────────
                const _HeadlineSection(),

                const Spacer(),

                // ── Auth Buttons ──────────────────────────────────────
                const _AuthButtons(),

                const SizedBox(height: 28),

                // ── Divider ───────────────────────────────────────────
                const _DividerRow(),

                const SizedBox(height: 24),

                // ── Guest option ──────────────────────────────────────
                const _GuestOption(),

                const SizedBox(height: 32),

                // ── Terms ─────────────────────────────────────────────
                const _TermsText(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Logo Section ─────────────────────────────────────────────────────────────
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo card
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              'assets/logo/logo_axon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Headline Section ─────────────────────────────────────────────────────────
class _HeadlineSection extends StatelessWidget {
  const _HeadlineSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to Axon',
          textAlign: TextAlign.center,
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.textDark,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Hire smarter. Earn faster.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─── Auth Buttons ─────────────────────────────────────────────────────────────
class _AuthButtons extends StatelessWidget {
  const _AuthButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isGoogleLoading = state is AuthGoogleLoading;

        return Column(
          children: [
            // ── Google ──────────────────────────────────────────────
            _SocialButton(
              label: 'Continue with Google',
              isLoading: isGoogleLoading,
              onTap: isGoogleLoading
                  ? null
                  : () => context
                      .read<AuthBloc>()
                      .add(const GoogleSignInRequested()),
              icon: _GoogleIcon(),
            ),

            const SizedBox(height: 14),

            // ── Email ────────────────────────────────────────────────
            PrimaryButton(
              label: 'Continue with Email',
              onTap: () => context
                  .read<AuthBloc>()
                  .add(const EmailSignInRequested()),
              icon: Icons.mail_outline_rounded,
              borderRadius: 28,
            ),
          ],
        );
      },
    );
  }
}

// ─── Social Button (Google style) ────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.onTap,
    required this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: AppTypography.buttonLarge.copyWith(
                      color: AppColors.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Google "G" Icon ──────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Blue arc (right)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -0.52, 1.57, false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Green arc (bottom)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.05, 1.57, false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Yellow arc (bottom-left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.62, 0.79, false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    // Red arc (left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      3.40, 1.15, false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );

    // White center cutout
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.62,
      Paint()..color = Colors.white,
    );

    // Horizontal bar of the "G"
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.82, cy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Divider Row ──────────────────────────────────────────────────────────────
class _DividerRow extends StatelessWidget {
  const _DividerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
      ],
    );
  }
}

// ─── Guest Option ─────────────────────────────────────────────────────────────
class _GuestOption extends StatelessWidget {
  const _GuestOption();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<AuthBloc>().add(const GuestBrowsingRequested()),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          'Browse as guest',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ─── Terms Text ───────────────────────────────────────────────────────────────
class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
          height: 1.6,
        ),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: AppTypography.caption.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTypography.caption.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
