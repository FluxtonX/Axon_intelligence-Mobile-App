import 'package:equatable/equatable.dart';
import '../../domain/entities/proposal_entity.dart';

enum ProposalsStatus { initial, loading, loaded, error }

class ProposalsState extends Equatable {
  final ProposalsStatus status;
  final String jobId;
  final List<ProposalEntity> proposals;
  final String? errorMessage;

  const ProposalsState({
    this.status = ProposalsStatus.initial,
    this.jobId = '',
    this.proposals = const [],
    this.errorMessage,
  });

  ProposalsState copyWith({
    ProposalsStatus? status,
    String? jobId,
    List<ProposalEntity>? proposals,
    String? errorMessage,
  }) {
    return ProposalsState(
      status: status ?? this.status,
      jobId: jobId ?? this.jobId,
      proposals: proposals ?? this.proposals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, jobId, proposals, errorMessage];
}
