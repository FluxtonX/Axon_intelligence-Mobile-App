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
