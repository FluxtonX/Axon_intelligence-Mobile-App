import 'package:equatable/equatable.dart';

enum DiscoverStatus { initial, searching, results }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final String query;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.query = '',
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    String? query,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [status, query];
}
