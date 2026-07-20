import '../../domain/entities/contract_entity.dart';
import '../../../../core/models/project_model.dart';

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    super.proposalId,
    required super.projectId,
    required super.clientId,
    required super.freelancerId,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.project,
    super.proposal,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String,
      proposalId: json['proposalId'] as String?,
      projectId: json['projectId'] as String,
      clientId: json['clientId'] as String,
      freelancerId: json['freelancerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      project: json['project'] != null ? ProjectModel.fromJson(json['project']) : null,
      proposal: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proposalId': proposalId,
      'projectId': projectId,
      'clientId': clientId,
      'freelancerId': freelancerId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
