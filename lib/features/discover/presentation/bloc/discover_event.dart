import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverSearchInitiated extends DiscoverEvent {
  final String query;

  const DiscoverSearchInitiated(this.query);

  @override
  List<Object?> get props => [query];
}

class DiscoverSearchCleared extends DiscoverEvent {}

class DiscoverFiltersUpdated extends DiscoverEvent {
  final String? selectedCategory;
  final double? minRating;
  final double? maxBudget;

  const DiscoverFiltersUpdated({
    this.selectedCategory,
    this.minRating,
    this.maxBudget,
  });

  @override
  List<Object?> get props => [selectedCategory, minRating, maxBudget];
}
