import 'package:equatable/equatable.dart';
import '../../../../core/blocs/user_mode_cubit.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverStarted extends DiscoverEvent {
  final UserMode userMode;

  const DiscoverStarted(this.userMode);

  @override
  List<Object?> get props => [userMode];
}

class DiscoverSearchInitiated extends DiscoverEvent {
  final String query;
  final UserMode userMode;

  const DiscoverSearchInitiated(this.query, this.userMode);

  @override
  List<Object?> get props => [query, userMode];
}

class DiscoverSearchCleared extends DiscoverEvent {}

class DiscoverFiltersUpdated extends DiscoverEvent {
  final UserMode userMode;
  final String? selectedCategory;
  final double? minRating;
  final double? maxBudget;

  const DiscoverFiltersUpdated({
    required this.userMode,
    this.selectedCategory,
    this.minRating,
    this.maxBudget,
  });

  @override
  List<Object?> get props => [userMode, selectedCategory, minRating, maxBudget];
}

class DiscoverLoadMore extends DiscoverEvent {
  final UserMode userMode;

  const DiscoverLoadMore(this.userMode);

  @override
  List<Object?> get props => [userMode];
}
