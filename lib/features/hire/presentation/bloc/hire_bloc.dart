import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../proposals/data/repositories/proposal_repository.dart';
import '../../../contracts/data/repositories/contract_repository.dart';
import 'hire_event.dart';
import 'hire_state.dart';

class HireBloc extends Bloc<HireEvent, HireState> {
  final ProposalRepository _proposalRepository;
  final ContractRepository _contractRepository;

  HireBloc(this._proposalRepository, this._contractRepository) : super(const HireState()) {
    on<HireInitialize>(_onInitialize);
    on<HireAcceptProposal>(_onAcceptProposal);
    on<HireProcessPayment>(_onProcessPayment);
  }

  void _onInitialize(HireInitialize event, Emitter<HireState> emit) {
    emit(state.copyWith(
      proposal: event.proposal,
      status: HireStatus.initial,
      contractId: null,
      errorMessage: null,
    ));
  }

  Future<void> _onAcceptProposal(
    HireAcceptProposal event,
    Emitter<HireState> emit,
  ) async {
    if (state.proposal == null) return;

    emit(state.copyWith(status: HireStatus.loading));

    try {
      final contractId = await _proposalRepository.acceptProposal(state.proposal!.id);

      emit(state.copyWith(
        status: HireStatus.contractCreated,
        contractId: contractId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Failed to accept proposal and create contract.',
      ));
    }
  }

  Future<void> _onProcessPayment(
    HireProcessPayment event,
    Emitter<HireState> emit,
  ) async {
    if (state.contractId == null) return;

    emit(state.copyWith(status: HireStatus.paymentProcessing));

    try {
      await _contractRepository.fundContract(state.contractId!);
      emit(state.copyWith(status: HireStatus.paymentSuccess));
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Payment failed. Please check your details.',
      ));
    }
  }
}
