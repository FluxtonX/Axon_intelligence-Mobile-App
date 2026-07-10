import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/onboarding_slide_model.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInProgress(0)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingCompleted>(_onCompleted);
  }

  final int _totalPages = onboardingSlides.length;

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingInProgress(event.page));
  }

  void _onNextPage(OnboardingNextPage event, Emitter<OnboardingState> emit) {
    final next = state.currentPage + 1;
    if (next >= _totalPages) {
      emit(const OnboardingDone());
    } else {
      emit(OnboardingInProgress(next));
    }
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(const OnboardingDone());
  }
}
