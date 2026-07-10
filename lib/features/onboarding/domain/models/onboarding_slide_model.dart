import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Data model for each onboarding slide
class OnboardingSlideModel {
  const OnboardingSlideModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.statValue,
    required this.statLabel,
    required this.statValueColor,
    required this.statBgColor,
  });

  final String title;
  final String description;

  /// Path to the Figma-exported PNG in assets/onboarding/
  final String imagePath;

  final String statValue;
  final String statLabel;
  final Color statValueColor;
  final Color statBgColor;
}

/// All 3 onboarding slides — content only, no UI
final List<OnboardingSlideModel> onboardingSlides = [
  const OnboardingSlideModel(
    title: 'Axon finds your\nperfect match',
    description:
        "Describe your project in plain English. Axon's AI understands "
        "context, budget, skills, and communication style to connect you "
        "with exactly the right talent.",
    imagePath: 'assets/onboarding/onboarding_container_1.png',
    statValue: '94%',
    statLabel: 'Average match accuracy',
    statValueColor: AppColors.ob1Accent,
    statBgColor: AppColors.ob1StatBg,
  ),
  const OnboardingSlideModel(
    title: 'Projects built for\nyour expertise',
    description:
        'No more proposal spam. Receive curated opportunities tailored to '
        'your skills, preferred industries, and work style. Quality over '
        'quantity, always.',
    imagePath: 'assets/onboarding/onboarding_container_2.png',
    statValue: '3x',
    statLabel: 'Faster hiring vs. traditional platforms',
    statValueColor: AppColors.ob2Accent,
    statBgColor: AppColors.ob2StatBg,
  ),
  const OnboardingSlideModel(
    title: 'Trust built into every\ninteraction',
    description:
        'Verified portfolios, multi-dimensional reputation scores, Axon '
        'success prediction, and milestone-based payments protect everyone.',
    imagePath: 'assets/onboarding/onboarding_container_3.png',
    statValue: '99.2%',
    statLabel: 'Client satisfaction rate',
    statValueColor: AppColors.ob3Accent,
    statBgColor: AppColors.ob3StatBg,
  ),
];
