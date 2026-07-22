import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';
import '../../../proposals/domain/entities/proposal_entity.dart';

enum HireStatus {
  initial,
  loading,
  contractCreated,
  paymentProcessing,
  paymentSuccess,
  error,
}

class HireState extends Equatable {
  final HireStatus status;
  final ProposalEntity? proposal;
  final String? contractId;
  final String? errorMessage;
  final double? directAmount; // Added for manual contracts

  const HireState({
    this.status = HireStatus.initial,
    this.proposal,
    this.contractId,
    this.errorMessage,
    this.directAmount,
  });

  HireState copyWith({
    HireStatus? status,
    ProposalEntity? proposal,
    String? contractId,
    String? errorMessage,
    double? directAmount,
  }) {
    return HireState(
      status: status ?? this.status,
      proposal: proposal ?? this.proposal,
      contractId: contractId ?? this.contractId,
      errorMessage: errorMessage ?? this.errorMessage,
      directAmount: directAmount ?? this.directAmount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        proposal,
        contractId,
        errorMessage,
        directAmount,
      ];
}
