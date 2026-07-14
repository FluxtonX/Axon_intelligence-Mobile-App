import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState(this.currentPage);
  final int currentPage;

  @override
  List<Object> get props => [currentPage];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial(super.currentPage);
}

class OnboardingDone extends OnboardingState {
  const OnboardingDone() : super(0);
}
