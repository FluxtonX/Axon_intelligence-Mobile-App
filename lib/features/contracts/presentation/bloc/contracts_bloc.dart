import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/contract_repository.dart';
import '../../data/repositories/reviews_repository.dart';
import 'contracts_event.dart';
import 'contracts_state.dart';

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  final ContractRepository _contractRepository;
  final ReviewsRepository _reviewsRepository;

  ContractsBloc(this._contractRepository, this._reviewsRepository) : super(const ContractsState()) {
    on<FetchMyContracts>(_onFetchMyContracts);
    on<FundContract>(_onFundContract);
    on<SubmitWork>(_onSubmitWork);
    on<ApproveWork>(_onApproveWork);
    on<LeaveReview>(_onLeaveReview);
  }

  Future<void> _onFetchMyContracts(FetchMyContracts event, Emitter<ContractsState> emit) async {
    emit(state.copyWith(status: ContractsStatus.loading, clearMessages: true));
    try {
      final contracts = await _contractRepository.getMyContracts();
      emit(state.copyWith(
        status: ContractsStatus.success,
        contracts: contracts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFundContract(FundContract event, Emitter<ContractsState> emit) async {
    emit(state.copyWith(status: ContractsStatus.approving, clearMessages: true));
    try {
      await _contractRepository.fundContract(event.contractId);
      emit(state.copyWith(
        status: ContractsStatus.success,
        actionSuccessMessage: 'Contract funded successfully! Status is now ACTIVE.',
      ));
      add(const FetchMyContracts()); // Refresh list
    } catch (e) {
      emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: 'Failed to fund contract.',
      ));
    }
  }

  Future<void> _onSubmitWork(SubmitWork event, Emitter<ContractsState> emit) async {
    emit(state.copyWith(status: ContractsStatus.submitting, clearMessages: true));
    try {
      await _contractRepository.submitWork(event.contractId, event.submissionDetails);
      emit(state.copyWith(
        status: ContractsStatus.success,
        actionSuccessMessage: 'Work submitted successfully!',
      ));
      add(const FetchMyContracts()); // Refresh list
    } catch (e) {
      emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: 'Failed to submit work.',
      ));
    }
  }

  Future<void> _onApproveWork(ApproveWork event, Emitter<ContractsState> emit) async {
    emit(state.copyWith(status: ContractsStatus.approving, clearMessages: true));
    try {
      await _contractRepository.approveWork(event.contractId);
      emit(state.copyWith(
        status: ContractsStatus.success,
        actionSuccessMessage: 'Work approved! Funds have been released.',
      ));
      add(const FetchMyContracts()); // Refresh list
    } catch (e) {
      emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: 'Failed to approve work.',
      ));
    }
  }

  Future<void> _onLeaveReview(LeaveReview event, Emitter<ContractsState> emit) async {
    emit(state.copyWith(status: ContractsStatus.approving, clearMessages: true)); // reusing approving status for loading
    try {
      await _reviewsRepository.createReview(event.contractId, event.revieweeId, event.rating, event.comment);
      emit(state.copyWith(
        status: ContractsStatus.success,
        actionSuccessMessage: 'Review submitted successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: 'Failed to submit review.',
      ));
    }
  }
}
