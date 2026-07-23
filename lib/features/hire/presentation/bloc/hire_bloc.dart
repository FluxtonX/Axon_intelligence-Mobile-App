import 'package:url_launcher/url_launcher.dart';
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
    on<HireCreateDirectContract>(_onCreateDirectContract);
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
      final checkoutUrl = await _contractRepository.createCheckoutSession(state.contractId!);
      final Uri url = Uri.parse(checkoutUrl);
      
      await launchUrl(url, mode: LaunchMode.externalApplication);
      // The user is redirected to the browser. We will assume success for the local state,
      // but ideally they should be taken to a waiting screen that polls for the contract status.
      emit(state.copyWith(status: HireStatus.paymentSuccess));
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Payment initialization failed: $e',
      ));
    }
  }

  Future<void> _onCreateDirectContract(
    HireCreateDirectContract event,
    Emitter<HireState> emit,
  ) async {
    emit(state.copyWith(status: HireStatus.loading, directAmount: event.amount));

    try {
      final contract = await _contractRepository.createDirectContract(
        freelancerId: event.freelancerId,
        title: event.title,
        description: event.description,
        amount: event.amount,
        deliveryDays: event.deliveryDays,
      );

      emit(state.copyWith(
        status: HireStatus.contractCreated,
        contractId: contract.id,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Failed to create direct contract: $e',
      ));
    }
  }
}
