import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';

abstract class ContractsEvent extends Equatable {
  const ContractsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyContracts extends ContractsEvent {
  const FetchMyContracts();
}

class SubmitWork extends ContractsEvent {
  final String contractId;
  final String submissionDetails;

  const SubmitWork({
    required this.contractId,
    required this.submissionDetails,
  });

  @override
  List<Object?> get props => [contractId, submissionDetails];
}

class ApproveWork extends ContractsEvent {
  final String contractId;

  const ApproveWork(this.contractId);

  @override
  List<Object?> get props => [contractId];
}
