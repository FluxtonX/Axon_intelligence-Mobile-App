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

class FundContract extends ContractsEvent {
  final String contractId;

  const FundContract(this.contractId);

  @override
  List<Object?> get props => [contractId];
}

class SubmitWork extends ContractsEvent {
  final String contractId;
  final String submissionDetails;
  final List<int>? fileBytes;
  final String? fileName;

  const SubmitWork({
    required this.contractId,
    required this.submissionDetails,
    this.fileBytes,
    this.fileName,
  });

  @override
  List<Object?> get props => [contractId, submissionDetails, fileBytes, fileName];
}

class ApproveWork extends ContractsEvent {
  final String contractId;

  const ApproveWork(this.contractId);

  @override
  List<Object?> get props => [contractId];
}

class LeaveReview extends ContractsEvent {
  final String contractId;
  final String revieweeId;
  final int rating;
  final String comment;

  const LeaveReview({
    required this.contractId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [contractId, revieweeId, rating, comment];
}
