import 'package:flutter_bloc/flutter_bloc.dart';
import 'gig_creation_event.dart';
import 'gig_creation_state.dart';
import '../../domain/entities/gig_entity.dart';

class GigCreationBloc extends Bloc<GigCreationEvent, GigCreationState> {
  GigCreationBloc() : super(const GigCreationState()) {
    on<GigSubmitted>(_onGigSubmitted);
  }

  Future<void> _onGigSubmitted(
    GigSubmitted event,
    Emitter<GigCreationState> emit,
  ) async {
    emit(state.copyWith(status: GigCreationStatus.loading));

    try {
      // Simulate network request to create a gig
      await Future.delayed(const Duration(seconds: 2));

      // Successfully created - add to local state list
      final updatedGigs = List<GigEntity>.from(state.gigs)..add(event.gig);
      
      emit(state.copyWith(
        status: GigCreationStatus.success,
        gigs: updatedGigs,
      ));
      
      // Reset back to initial so they can create another one later, but keep the gigs
      emit(state.copyWith(status: GigCreationStatus.initial));
    } catch (e) {
      emit(state.copyWith(
        status: GigCreationStatus.error,
        errorMessage: 'Failed to publish service. Please try again.',
      ));
    }
  }
}
