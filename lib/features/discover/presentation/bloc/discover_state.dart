import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';

enum DiscoverStatus { initial, searching, results }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final String query;
  final String? selectedCategory;
  final double? minRating;
  final double? maxBudget;
  final List<UserModel> topFreelancers;
  final List<UserModel> results;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.query = '',
    this.selectedCategory,
    this.minRating,
    this.maxBudget,
    this.topFreelancers = const [],
    this.results = const [],
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    String? query,
    String? selectedCategory,
    double? minRating,
    double? maxBudget,
    List<UserModel>? topFreelancers,
    List<UserModel>? results,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minRating: minRating ?? this.minRating,
      maxBudget: maxBudget ?? this.maxBudget,
      topFreelancers: topFreelancers ?? this.topFreelancers,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [status, query, selectedCategory, minRating, maxBudget, topFreelancers, results];
}
