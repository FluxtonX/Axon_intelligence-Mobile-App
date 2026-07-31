import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/discover_repository.dart';
import '../../../projects/data/repositories/project_repository.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository _repository;
  final ProjectRepository _projectRepository;

  DiscoverBloc(this._repository, this._projectRepository) : super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverSearchInitiated>(_onSearchInitiated);
    on<DiscoverSearchCleared>(_onSearchCleared);
    on<DiscoverFiltersUpdated>(_onFiltersUpdated);
    on<DiscoverLoadMore>(_onLoadMore);
  }

  Future<void> _onStarted(DiscoverStarted event, Emitter<DiscoverState> emit) async {
    try {
      if (event.userMode == UserMode.client) {
        final topFreelancers = await _repository.searchFreelancers(query: '');
        emit(state.copyWith(topFreelancers: topFreelancers));
      } else {
        final availableProjects = await _projectRepository.getAvailableProjects();
        emit(state.copyWith(availableProjects: availableProjects));
      }
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
      if (event.userMode == UserMode.client) {
        final results = await _repository.searchFreelancers(
          query: event.query,
          maxHourlyRate: state.maxBudget,
          minRating: state.minRating,
          category: state.selectedCategory,
          page: 1,
          limit: 20,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: DiscoverStatus.results,
          results: results,
          currentPage: 1,
          hasReachedMax: results.length < 20,
        ));
      } else {
        // Freelancer is searching projects (can implement search logic later)
        // For now just return available projects
        final projects = await _projectRepository.getAvailableProjects();
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: DiscoverStatus.results,
          projectResults: projects,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.results,
        results: [],
        projectResults: [],
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

  Future<void> _onFiltersUpdated(
    DiscoverFiltersUpdated event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(
      selectedCategory: event.selectedCategory,
      minRating: event.minRating,
      maxBudget: event.maxBudget,
    ));

    if (state.status == DiscoverStatus.initial && state.query.isEmpty) {
      try {
        if (event.userMode == UserMode.client) {
          final topFreelancers = await _repository.searchFreelancers(
            category: event.selectedCategory,
            minRating: event.minRating,
            maxHourlyRate: event.maxBudget,
            limit: 20,
          );
          emit(state.copyWith(topFreelancers: topFreelancers));
        } else {
          final availableProjects = await _projectRepository.getAvailableProjects();
          emit(state.copyWith(availableProjects: availableProjects));
        }
      } catch (e) {
        // Handle gracefully
      }
    } else {
      add(DiscoverSearchInitiated(state.query, event.userMode));
    }
  }

  Future<void> _onLoadMore(
    DiscoverLoadMore event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state.hasReachedMax || state.status != DiscoverStatus.results) return;

    try {
      if (event.userMode == UserMode.client) {
        final nextPage = state.currentPage + 1;
        final newResults = await _repository.searchFreelancers(
          query: state.query,
          maxHourlyRate: state.maxBudget,
          minRating: state.minRating,
          category: state.selectedCategory,
          page: nextPage,
          limit: 20,
        );
        
        emit(state.copyWith(
          results: List.of(state.results)..addAll(newResults),
          currentPage: nextPage,
          hasReachedMax: newResults.length < 20,
        ));
      }
    } catch (e) {
      // Handle error gracefully or ignore
    }
  }
}
