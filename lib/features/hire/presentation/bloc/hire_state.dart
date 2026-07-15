import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';

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
  final String freelancerName;
  final String freelancerId;
  final List<MilestoneEntity> milestones;
  final ContractEntity? contract;
  final String? errorMessage;

  const HireState({
    this.status = HireStatus.initial,
    this.freelancerName = '',
    this.freelancerId = '',
    this.milestones = const [],
    this.contract,
    this.errorMessage,
  });

  double get totalAmount {
    return milestones.fold(0, (sum, item) => sum + item.amount);
  }

  HireState copyWith({
    HireStatus? status,
    String? freelancerName,
    String? freelancerId,
    List<MilestoneEntity>? milestones,
    ContractEntity? contract,
    String? errorMessage,
  }) {
    return HireState(
      status: status ?? this.status,
      freelancerName: freelancerName ?? this.freelancerName,
      freelancerId: freelancerId ?? this.freelancerId,
      milestones: milestones ?? this.milestones,
      contract: contract ?? this.contract,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        freelancerName,
        freelancerId,
        milestones,
        contract,
        errorMessage,
      ];
}
