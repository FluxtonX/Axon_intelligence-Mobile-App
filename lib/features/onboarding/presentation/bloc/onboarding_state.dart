import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState(this.currentPage);
  final int currentPage;
  @override
  List<Object?> get props => [currentPage];
}

class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress(super.currentPage);
}

class OnboardingDone extends OnboardingState {
  const OnboardingDone() : super(2);
}
