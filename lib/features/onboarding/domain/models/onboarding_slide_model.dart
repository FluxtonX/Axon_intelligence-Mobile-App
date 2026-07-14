class OnboardingSlideModel {
  const OnboardingSlideModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}

final List<OnboardingSlideModel> onboardingSlides = [
  const OnboardingSlideModel(
    title: 'Welcome to Axon',
    description: 'Discover a world of top-tier talent, curated just for you. Your next big project starts here.',
    imagePath: 'assets/onboarding/slide_1.png',
  ),
  const OnboardingSlideModel(
    title: 'Find the Best Talent',
    description: 'Connect with verified experts, share your vision, and discover unparalleled growth.',
    imagePath: 'assets/onboarding/slide_2.png',
  ),
  const OnboardingSlideModel(
    title: 'Easy Hiring Process',
    description: 'Customize your milestones, track progress in real-time, and enjoy a seamless experience.',
    imagePath: 'assets/onboarding/slide_3.png',
  ),
];
