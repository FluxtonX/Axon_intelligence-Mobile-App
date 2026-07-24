import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import 'seller_onboarding_event.dart';
import 'seller_onboarding_state.dart';

class SellerOnboardingBloc extends Bloc<SellerOnboardingEvent, SellerOnboardingState> {
  final ProfileRepository _profileRepository;

  SellerOnboardingBloc(this._profileRepository) : super(SellerOnboardingInitial()) {
    on<SubmitSellerProfile>(_onSubmitSellerProfile);
  }

  Future<void> _onSubmitSellerProfile(
    SubmitSellerProfile event,
    Emitter<SellerOnboardingState> emit,
  ) async {
    emit(SellerOnboardingLoading());
    try {
      await _profileRepository.updateProfile(
        title: event.title,
        bio: event.bio,
        skills: event.skills,
        hourlyRate: event.hourlyRate,
      );
      emit(SellerOnboardingSuccess());
    } catch (e) {
      emit(SellerOnboardingFailure(e.toString()));
    }
  }
}
