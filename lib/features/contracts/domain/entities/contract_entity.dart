import 'package:equatable/equatable.dart';
import '../../../../core/models/project_model.dart';
import '../../../proposals/domain/entities/proposal_entity.dart';

class ContractEntity extends Equatable {
  final String id;
  final String? proposalId;
  final String projectId;
  final String clientId;
  final String freelancerId;
  final double amount;
  final String status;
  final DateTime createdAt;

  final ProjectModel? project;
  final ProposalEntity? proposal;

  const ContractEntity({
    required this.id,
    this.proposalId,
    required this.projectId,
    required this.clientId,
    required this.freelancerId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.project,
    this.proposal,
  });

  @override
  List<Object?> get props => [
        id,
        proposalId,
        projectId,
        clientId,
        freelancerId,
        amount,
        status,
        createdAt,
        project,
        proposal,
      ];
}
