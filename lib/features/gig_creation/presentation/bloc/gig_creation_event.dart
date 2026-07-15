import 'package:equatable/equatable.dart';
import '../../domain/entities/gig_entity.dart';

abstract class GigCreationEvent extends Equatable {
  const GigCreationEvent();

  @override
  List<Object?> get props => [];
}

class GigSubmitted extends GigCreationEvent {
  final GigEntity gig;

  const GigSubmitted(this.gig);

  @override
  List<Object?> get props => [gig];
}
