import 'package:flutter_bloc/flutter_bloc.dart';
import 'find_work_event.dart';
import 'find_work_state.dart';
import '../../../projects/data/repositories/project_repository.dart';

class FindWorkBloc extends Bloc<FindWorkEvent, FindWorkState> {
  final ProjectRepository projectRepository;

  FindWorkBloc({required this.projectRepository}) : super(FindWorkInitial()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<LoadMoreProjectsEvent>(_onLoadMoreProjects);
  }

  Future<void> _onLoadProjects(LoadProjectsEvent event, Emitter<FindWorkState> emit) async {
    emit(FindWorkLoading());
    try {
      final projects = await projectRepository.getAvailableProjects(page: 1, limit: 10);
      emit(FindWorkLoaded(
        projects: projects,
        hasReachedMax: projects.length < 10,
        currentPage: 1,
      ));
    } catch (e) {
      emit(FindWorkError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProjects(LoadMoreProjectsEvent event, Emitter<FindWorkState> emit) async {
    if (state is FindWorkLoaded) {
      final currentState = state as FindWorkLoaded;
      if (currentState.hasReachedMax) return;

      try {
        final nextPage = currentState.currentPage + 1;
        final projects = await projectRepository.getAvailableProjects(page: nextPage, limit: 10);
        emit(projects.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : currentState.copyWith(
                projects: List.of(currentState.projects)..addAll(projects),
                currentPage: nextPage,
                hasReachedMax: projects.length < 10,
              ));
      } catch (e) {
        emit(FindWorkError(e.toString()));
      }
    }
  }
}
