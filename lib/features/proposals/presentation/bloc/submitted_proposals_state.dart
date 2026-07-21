import 'package:equatable/equatable.dart';
import '../../domain/entities/proposal_entity.dart';

enum SubmittedProposalsStatus { initial, loading, loaded, error }

class SubmittedProposalsState extends Equatable {
  final SubmittedProposalsStatus status;
  final List<ProposalEntity> proposals;
  final String? errorMessage;

  const SubmittedProposalsState({
    this.status = SubmittedProposalsStatus.initial,
    this.proposals = const [],
    this.errorMessage,
  });

  SubmittedProposalsState copyWith({
    SubmittedProposalsStatus? status,
    List<ProposalEntity>? proposals,
    String? errorMessage,
  }) {
    return SubmittedProposalsState(
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, proposals, errorMessage];
}
