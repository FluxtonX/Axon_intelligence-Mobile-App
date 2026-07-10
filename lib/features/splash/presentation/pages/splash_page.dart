import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(const SplashStarted()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  // ─── Animation controllers ────────────────────────────────────────────────
  late AnimationController _logoController;
  late AnimationController _contentController;

  // ─── Logo animations ──────────────────────────────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // ─── Content animations ───────────────────────────────────────────────────
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    // Sequence: logo → then text
    _logoController.forward().then((_) {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToAuth) {
          context.go('/onboarding');
        } else if (state is SplashNavigateToHome) {
          // TODO: context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.splashGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),
                // ── Logo ────────────────────────────────────────────────
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: const _LogoWidget(),
                ),

                const SizedBox(height: 40),

                // ── App name + tagline + description ─────────────────
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentOpacity.value,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: child,
                      ),
                    );
                  },
                  child: const _TextContent(),
                ),

                const Spacer(flex: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Logo Widget ──────────────────────────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 50,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Image.asset(
          'assets/logo/logo_axon.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// ─── Text Content ─────────────────────────────────────────────────────────────
class _TextContent extends StatelessWidget {
  const _TextContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // ── "Axon" ──────────────────────────────────────────────────
          Text(
            'Axon',
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 42,
              letterSpacing: -1.0,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 10),

          // ── "INTELLIGENT FREELANCING" ────────────────────────────
          Text(
            'INTELLIGENT FREELANCING',
            style: AppTypography.labelMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 3.2,
            ),
          ),

          const SizedBox(height: 24),

          // ── Description ──────────────────────────────────────────
          Text(
            'AI connects you with the world\'s best\ntalent — instantly.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.40),
              fontSize: 14,
              height: 1.65,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
