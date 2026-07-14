import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial(0)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingInitial(event.pageIndex));
  }

  void _onNextPage(
    OnboardingNextPage event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentPage < 2) {
      emit(OnboardingInitial(state.currentPage + 1));
    }
  }

  void _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(const OnboardingDone());
  }
}
