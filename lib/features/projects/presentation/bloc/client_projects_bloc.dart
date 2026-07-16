import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_projects_state.dart';
import '../../data/repositories/project_repository.dart';
import '../../../../core/models/project_model.dart';

abstract class ClientProjectsEvent {}

class LoadClientProjectsEvent extends ClientProjectsEvent {}

class PublishProjectEvent extends ClientProjectsEvent {
  final String title;
  final String description;
  final double budget;
  final String? timeline;
  final List<String> skills;
  
  PublishProjectEvent({
    required this.title,
    required this.description,
    required this.budget,
    this.timeline,
    this.skills = const [],
  });
}

class ResetPublishStatusEvent extends ClientProjectsEvent {}

class ClientProjectsBloc extends Bloc<ClientProjectsEvent, ClientProjectsState> {
  final ProjectRepository _repository;

  ClientProjectsBloc(this._repository) : super(const ClientProjectsState()) {
    on<LoadClientProjectsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final projects = await _repository.getMyProjects();
        emit(state.copyWith(projects: projects, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<PublishProjectEvent>((event, emit) async {
      emit(state.copyWith(publishStatus: PublishStatus.loading, publishError: null));
      try {
        final newProject = await _repository.createProject(
          title: event.title,
          description: event.description,
          budget: event.budget,
          timeline: event.timeline,
          skills: event.skills,
        );
        final updatedList = List<ProjectModel>.from(state.projects)..insert(0, newProject);
        emit(state.copyWith(projects: updatedList, publishStatus: PublishStatus.success));
      } catch (e) {
        emit(state.copyWith(publishStatus: PublishStatus.failure, publishError: e.toString()));
      }
    });

    on<ResetPublishStatusEvent>((event, emit) {
      emit(state.copyWith(publishStatus: PublishStatus.initial, publishError: null));
    });
  }
}
