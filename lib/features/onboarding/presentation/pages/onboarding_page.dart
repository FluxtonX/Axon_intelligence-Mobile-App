import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
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

  void _onNext(BuildContext context, int currentPage) {
    final bloc = context.read<OnboardingBloc>();
    if (currentPage < onboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
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
          context.go('/auth');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ── Background Images (Top 65%) ──────────────────────
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingSlides.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (page) => context
                  .read<OnboardingBloc>()
                  .add(OnboardingPageChanged(page)),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: Image.asset(
                        onboardingSlides[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── Bottom White Sheet (Adaptive Height) ─────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
                child: SafeArea(
                  top: false,
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      final slide = onboardingSlides[state.currentPage];
                      final isLastPage = state.currentPage == onboardingSlides.length - 1;
                      
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // Title
                        Text(
                          slide.title,
                          style: AppTypography.displayLarge.copyWith(
                            color: const Color(0xFF111827), // Gray 900
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Description
                        Text(
                          slide.description,
                          style: AppTypography.bodyLarge.copyWith(
                            color: const Color(0xFF6B7280), // Gray 500
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Bottom Row (Dots & Button)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dots
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(onboardingSlides.length, (index) {
                                final isActive = index == state.currentPage;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 6),
                                  width: isActive ? 24 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                            
                            // Next Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _onNext(context, state.currentPage),
                                borderRadius: BorderRadius.circular(30),
                                child: Ink(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLastPage ? 32 : 24, 
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isLastPage ? 'Get Started' : 'Next',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (!isLastPage) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
            ), // closes Align
          ],
        ),
      ),
    );
  }
}
