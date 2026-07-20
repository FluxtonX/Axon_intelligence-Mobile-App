import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/proposal_entity.dart';
import '../../data/repositories/proposal_repository.dart';
import 'proposals_event.dart';
import 'proposals_state.dart';

class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  final ProposalRepository proposalRepository;

  ProposalsBloc(this.proposalRepository) : super(const ProposalsState()) {
    on<ProposalsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    ProposalsFetchRequested event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(status: ProposalsStatus.loading, jobId: event.jobId));

    try {
      final proposals = await proposalRepository.getProposalsForProject(event.jobId);


      emit(state.copyWith(
        status: ProposalsStatus.loaded,
        proposals: proposals,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProposalsStatus.error,
        errorMessage: 'Failed to load proposals',
      ));
    }
  }
}
