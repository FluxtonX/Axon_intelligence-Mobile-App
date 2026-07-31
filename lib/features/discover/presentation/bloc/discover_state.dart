import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/project_model.dart';

enum DiscoverStatus { initial, searching, results }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final String query;
  final String? selectedCategory;
  final double? minRating;
  final double? maxBudget;
  final List<UserModel> topFreelancers;
  final List<UserModel> results;
  final List<ProjectModel> availableProjects;
  final List<ProjectModel> projectResults;
  final int currentPage;
  final bool hasReachedMax;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.query = '',
    this.selectedCategory,
    this.minRating,
    this.maxBudget,
    this.topFreelancers = const [],
    this.results = const [],
    this.availableProjects = const [],
    this.projectResults = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    String? query,
    String? selectedCategory,
    double? minRating,
    double? maxBudget,
    List<UserModel>? topFreelancers,
    List<UserModel>? results,
    List<ProjectModel>? availableProjects,
    List<ProjectModel>? projectResults,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minRating: minRating ?? this.minRating,
      maxBudget: maxBudget ?? this.maxBudget,
      topFreelancers: topFreelancers ?? this.topFreelancers,
      results: results ?? this.results,
      availableProjects: availableProjects ?? this.availableProjects,
      projectResults: projectResults ?? this.projectResults,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status, query, selectedCategory, minRating, maxBudget, 
    topFreelancers, results, availableProjects, projectResults,
    currentPage, hasReachedMax
  ];
}
