import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_projects_state.dart';

abstract class ClientProjectsEvent {}

class PublishProjectEvent extends ClientProjectsEvent {
  final ClientProjectEntity project;
  PublishProjectEvent(this.project);
}

class ClientProjectsBloc extends Bloc<ClientProjectsEvent, ClientProjectsState> {
  ClientProjectsBloc() : super(const ClientProjectsState()) {
    on<PublishProjectEvent>((event, emit) {
      final updatedList = List<ClientProjectEntity>.from(state.projects)..insert(0, event.project);
      emit(state.copyWith(projects: updatedList));
    });
  }
}
