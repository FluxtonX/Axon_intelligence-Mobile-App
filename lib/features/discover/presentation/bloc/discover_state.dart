import 'package:equatable/equatable.dart';

enum DiscoverStatus { initial, searching, results }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final String query;
  final String? selectedCategory;
  final double? minRating;
  final double? maxBudget;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.query = '',
    this.selectedCategory,
    this.minRating,
    this.maxBudget,
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    String? query,
    String? selectedCategory,
    double? minRating,
    double? maxBudget,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minRating: minRating ?? this.minRating,
      maxBudget: maxBudget ?? this.maxBudget,
    );
  }

  @override
  List<Object?> get props => [status, query, selectedCategory, minRating, maxBudget];
}
