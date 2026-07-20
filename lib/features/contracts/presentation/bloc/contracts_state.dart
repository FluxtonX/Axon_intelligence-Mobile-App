import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';

enum ContractsStatus { initial, loading, success, failure, submitting, approving }

class ContractsState extends Equatable {
  final ContractsStatus status;
  final List<ContractEntity> contracts;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const ContractsState({
    this.status = ContractsStatus.initial,
    this.contracts = const [],
    this.errorMessage,
    this.actionSuccessMessage,
  });

  ContractsState copyWith({
    ContractsStatus? status,
    List<ContractEntity>? contracts,
    String? errorMessage,
    String? actionSuccessMessage,
    bool clearMessages = false,
  }) {
    return ContractsState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      actionSuccessMessage: clearMessages ? null : (actionSuccessMessage ?? this.actionSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [status, contracts, errorMessage, actionSuccessMessage];
}
