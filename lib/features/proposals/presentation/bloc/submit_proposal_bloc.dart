import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/proposal_repository.dart';
import 'submit_proposal_event.dart';
import 'submit_proposal_state.dart';

class SubmitProposalBloc extends Bloc<SubmitProposalEvent, SubmitProposalState> {
  final ProposalRepository proposalRepository;

  SubmitProposalBloc(this.proposalRepository) : super(SubmitProposalInitial()) {
    on<SubmitProposalRequested>(_onSubmitProposalRequested);
  }

  Future<void> _onSubmitProposalRequested(
    SubmitProposalRequested event,
    Emitter<SubmitProposalState> emit,
  ) async {
    emit(SubmitProposalLoading());
    try {
      await proposalRepository.submitProposal(
        projectId: event.projectId,
        bidAmount: event.bidAmount,
        deliveryDays: event.deliveryDays,
        coverLetter: event.coverLetter,
      );
      emit(SubmitProposalSuccess());
    } catch (e) {
      emit(SubmitProposalFailure(e.toString()));
    }
  }
}
