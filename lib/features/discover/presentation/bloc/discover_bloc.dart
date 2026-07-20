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
        );
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: DiscoverStatus.results,
          results: results,
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
