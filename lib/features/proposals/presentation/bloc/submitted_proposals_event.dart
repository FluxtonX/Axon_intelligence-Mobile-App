import 'package:equatable/equatable.dart';

abstract class SubmittedProposalsEvent extends Equatable {
  const SubmittedProposalsEvent();

  @override
  List<Object?> get props => [];
}

class SubmittedProposalsFetchRequested extends SubmittedProposalsEvent {}
