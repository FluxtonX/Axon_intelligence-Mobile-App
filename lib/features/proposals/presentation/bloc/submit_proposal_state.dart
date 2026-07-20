import 'package:equatable/equatable.dart';

abstract class SubmitProposalState extends Equatable {
  const SubmitProposalState();

  @override
  List<Object> get props => [];
}

class SubmitProposalInitial extends SubmitProposalState {}

class SubmitProposalLoading extends SubmitProposalState {}

class SubmitProposalSuccess extends SubmitProposalState {}

class SubmitProposalFailure extends SubmitProposalState {
  final String error;

  const SubmitProposalFailure(this.error);

  @override
  List<Object> get props => [error];
}
