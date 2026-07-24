import 'package:equatable/equatable.dart';

abstract class SellerOnboardingEvent extends Equatable {
  const SellerOnboardingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitSellerProfile extends SellerOnboardingEvent {
  final String title;
  final String bio;
  final List<String> skills;
  final double hourlyRate;

  const SubmitSellerProfile({
    required this.title,
    required this.bio,
    required this.skills,
    required this.hourlyRate,
  });

  @override
  List<Object?> get props => [title, bio, skills, hourlyRate];
}
