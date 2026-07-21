import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/proposal_repository.dart';
import 'submitted_proposals_event.dart';
import 'submitted_proposals_state.dart';

class SubmittedProposalsBloc extends Bloc<SubmittedProposalsEvent, SubmittedProposalsState> {
  final ProposalRepository proposalRepository;

  SubmittedProposalsBloc(this.proposalRepository) : super(const SubmittedProposalsState()) {
    on<SubmittedProposalsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    SubmittedProposalsFetchRequested event,
    Emitter<SubmittedProposalsState> emit,
  ) async {
    emit(state.copyWith(status: SubmittedProposalsStatus.loading));

    try {
      final proposals = await proposalRepository.getMyProposals();
      emit(state.copyWith(
        status: SubmittedProposalsStatus.loaded,
        proposals: proposals,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubmittedProposalsStatus.error,
        errorMessage: 'Failed to load submitted proposals',
      ));
    }
  }
}
