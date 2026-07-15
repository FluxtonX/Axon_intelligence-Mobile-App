import 'package:equatable/equatable.dart';

abstract class ProposalsEvent extends Equatable {
  const ProposalsEvent();

  @override
  List<Object?> get props => [];
}

class ProposalsFetchRequested extends ProposalsEvent {
  final String jobId;

  const ProposalsFetchRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
