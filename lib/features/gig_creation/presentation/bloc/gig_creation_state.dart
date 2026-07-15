import 'package:equatable/equatable.dart';
import '../../domain/entities/gig_entity.dart';

enum GigCreationStatus { initial, loading, success, error }

class GigCreationState extends Equatable {
  final GigCreationStatus status;
  final String? errorMessage;
  final List<GigEntity> gigs;

  const GigCreationState({
    this.status = GigCreationStatus.initial,
    this.errorMessage,
    this.gigs = const [],
  });

  GigCreationState copyWith({
    GigCreationStatus? status,
    String? errorMessage,
    List<GigEntity>? gigs,
  }) {
    return GigCreationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      gigs: gigs ?? this.gigs,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, gigs];
}
