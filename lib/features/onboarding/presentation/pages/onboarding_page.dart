import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models/onboarding_slide_model.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onContinue(BuildContext context, int currentPage) {
    final bloc = context.read<OnboardingBloc>();
    if (currentPage < onboardingSlides.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOutCubic,
      );
      bloc.add(const OnboardingNextPage());
    } else {
      bloc.add(const OnboardingCompleted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingDone) {
          // TODO: context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  // ── Slide content fills all available space ───────────
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingSlides.length,
                      onPageChanged: (page) => context
                          .read<OnboardingBloc>()
                          .add(OnboardingPageChanged(page)),
                      itemBuilder: (_, index) => _OnboardingSlide(
                        slide: onboardingSlides[index],
                      ),
                    ),
                  ),

                  // ── Page Dots ────────────────────────────────────────
                  _PageIndicator(
                    total: onboardingSlides.length,
                    current: state.currentPage,
                  ),

                  const SizedBox(height: 20),

                  // ── Continue / Get Started Button ─────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PrimaryButton(
                      label: state.currentPage == onboardingSlides.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      onTap: () => _onContinue(context, state.currentPage),
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Single Slide ─────────────────────────────────────────────────────────────
class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.slide});
  final OnboardingSlideModel slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top gap (from status bar / notch area) ───────────────
          const SizedBox(height: 52),

          // ── Figma icon PNG (centered horizontally) ───────────────
          Center(
            child: Image.asset(
              slide.imagePath,
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 32),

          // ── Heading ───────────────────────────────────────────────
          Text(
            slide.title,
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textDark,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.3,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 12),

          // ── Description ───────────────────────────────────────────
          Text(
            slide.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13.5,
              height: 1.65,
            ),
          ),

          const SizedBox(height: 28),

          // ── Stat Card ─────────────────────────────────────────────
          _StatCard(slide: slide),

          // ── Push dots + button to bottom ─────────────────────────
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({required this.slide});
  final OnboardingSlideModel slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: slide.statBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            slide.statValue,
            style: AppTypography.headingMedium.copyWith(
              color: slide.statValueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            slide.statLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page Indicator Dots ──────────────────────────────────────────────────────
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.total, required this.current});
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: AppConstants.animationFast,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3.5),
          width: isActive ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
        );
      }),
    );
  }
}
