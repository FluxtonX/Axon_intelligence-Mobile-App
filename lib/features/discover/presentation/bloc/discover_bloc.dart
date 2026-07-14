import 'package:flutter_bloc/flutter_bloc.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc() : super(const DiscoverState()) {
    on<DiscoverSearchInitiated>(_onSearchInitiated);
    on<DiscoverSearchCleared>(_onSearchCleared);
    on<DiscoverFiltersUpdated>(_onFiltersUpdated);
  }

  Future<void> _onSearchInitiated(
    DiscoverSearchInitiated event,
    Emitter<DiscoverState> emit,
  ) async {
    // Transition to the searching (loading) state with the query
    emit(state.copyWith(
      status: DiscoverStatus.searching,
      query: event.query,
    ));

    // Simulate network delay to show the premium searching animation
    await Future.delayed(const Duration(milliseconds: 2500));

    // Transition to results state
    emit(state.copyWith(status: DiscoverStatus.results));
  }

  void _onSearchCleared(
    DiscoverSearchCleared event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(
      status: DiscoverStatus.initial,
      query: '',
    ));
  }

  void _onFiltersUpdated(
    DiscoverFiltersUpdated event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.selectedCategory,
      minRating: event.minRating,
      maxBudget: event.maxBudget,
    ));
  }
}
