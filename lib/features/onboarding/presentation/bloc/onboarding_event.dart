import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);
  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}

class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
