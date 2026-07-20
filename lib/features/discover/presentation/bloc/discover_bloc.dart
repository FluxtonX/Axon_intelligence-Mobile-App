import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/discover_repository.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository _repository;

  DiscoverBloc(this._repository) : super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverSearchInitiated>(_onSearchInitiated);
    on<DiscoverSearchCleared>(_onSearchCleared);
    on<DiscoverFiltersUpdated>(_onFiltersUpdated);
  }

  Future<void> _onStarted(DiscoverStarted event, Emitter<DiscoverState> emit) async {
    try {
      final topFreelancers = await _repository.searchFreelancers(query: '');
      emit(state.copyWith(topFreelancers: topFreelancers));
    } catch (e) {
      // Keep empty if failed
    }
  }

  Future<void> _onSearchInitiated(
    DiscoverSearchInitiated event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(
      status: DiscoverStatus.searching,
      query: event.query,
    ));

    try {
      final results = await _repository.searchFreelancers(
        query: event.query,
        maxHourlyRate: state.maxBudget,
      );
      
      // Let the searching animation play at least a bit to feel premium, or just show immediately.
      // We can do a tiny delay to not jar the user if it's too fast.
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
        status: DiscoverStatus.results,
        results: results,
      ));
    } catch (e) {
      // In a real app we'd handle error states, but for now just show empty results
      emit(state.copyWith(
        status: DiscoverStatus.results,
        results: [],
      ));
    }
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
