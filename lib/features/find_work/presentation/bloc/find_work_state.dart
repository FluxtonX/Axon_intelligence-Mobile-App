import 'package:equatable/equatable.dart';
import '../../../../core/models/project_model.dart';

abstract class FindWorkState extends Equatable {
  const FindWorkState();

  @override
  List<Object> get props => [];
}

class FindWorkInitial extends FindWorkState {}

class FindWorkLoading extends FindWorkState {}

class FindWorkLoaded extends FindWorkState {
  final List<ProjectModel> projects;
  final bool hasReachedMax;
  final int currentPage;

  const FindWorkLoaded({
    required this.projects,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  FindWorkLoaded copyWith({
    List<ProjectModel>? projects,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return FindWorkLoaded(
      projects: projects ?? this.projects,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [projects, hasReachedMax, currentPage];
}

class FindWorkError extends FindWorkState {
  final String message;

  const FindWorkError(this.message);

  @override
  List<Object> get props => [message];
}
