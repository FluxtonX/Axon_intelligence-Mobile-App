import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.page);
  final int page;
  @override
  List<Object?> get props => [page];
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
