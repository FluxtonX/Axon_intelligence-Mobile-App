import 'package:equatable/equatable.dart';
import '../../../../core/models/project_model.dart';

enum PublishStatus { initial, loading, success, failure }

class ClientProjectsState extends Equatable {
  final List<ProjectModel> projects;
  final bool isLoading;
  final String? error;
  final PublishStatus publishStatus;
  final String? publishError;

  const ClientProjectsState({
    this.projects = const [],
    this.isLoading = false,
    this.error,
    this.publishStatus = PublishStatus.initial,
    this.publishError,
  });

  ClientProjectsState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
    PublishStatus? publishStatus,
    String? publishError,
  }) {
    return ClientProjectsState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      publishStatus: publishStatus ?? this.publishStatus,
      publishError: publishError,
    );
  }

  @override
  List<Object?> get props => [projects, isLoading, error, publishStatus, publishError];
}
