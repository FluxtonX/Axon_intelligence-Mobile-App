import 'package:equatable/equatable.dart';

class ClientProjectEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String budget;
  final String timeline;
  final DateTime createdAt;

  const ClientProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.timeline,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, budget, timeline, createdAt];
}

class ClientProjectsState extends Equatable {
  final List<ClientProjectEntity> projects;

  const ClientProjectsState({
    this.projects = const [],
  });

  ClientProjectsState copyWith({
    List<ClientProjectEntity>? projects,
  }) {
    return ClientProjectsState(
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [projects];
}
