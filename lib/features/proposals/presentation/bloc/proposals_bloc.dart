import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/proposal_entity.dart';
import 'proposals_event.dart';
import 'proposals_state.dart';

class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  ProposalsBloc() : super(const ProposalsState()) {
    on<ProposalsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    ProposalsFetchRequested event,
    Emitter<ProposalsState> emit,
  ) async {
    emit(state.copyWith(status: ProposalsStatus.loading, jobId: event.jobId));

    try {
      // Simulate network delay for fetching proposals
      await Future.delayed(const Duration(seconds: 1));

      // Mock Data
      final proposals = [
        ProposalEntity(
          id: 'prop_1',
          freelancerId: 'free_1',
          freelancerName: 'Alex Mercer',
          freelancerTitle: 'Senior Full-Stack Developer',
          freelancerImageUrl: 'https://i.pravatar.cc/150?img=11',
          freelancerRating: 4.9,
          matchPercentage: 95,
          coverLetter: 'Hi there! I read your brief and I am very confident I can build this custom Flutter app for you. I have 5 years of experience with BLoC and Firebase, perfectly matching your stack requirements. I can deliver the MVP within 14 days.',
          bidAmount: 1200.0,
          estimatedDays: 14,
          submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ProposalEntity(
          id: 'prop_2',
          freelancerId: 'free_2',
          freelancerName: 'Sarah Jenkins',
          freelancerTitle: 'UI/UX Designer & Flutter Dev',
          freelancerImageUrl: 'https://i.pravatar.cc/150?img=5',
          freelancerRating: 4.8,
          matchPercentage: 88,
          coverLetter: 'Hello! Your project looks exciting. I specialize in building beautiful, highly-animated Flutter applications. While my bid is slightly higher, I will include a custom design system and Figma source files.',
          bidAmount: 1500.0,
          estimatedDays: 20,
          submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ProposalEntity(
          id: 'prop_3',
          freelancerId: 'free_3',
          freelancerName: 'David Chen',
          freelancerTitle: 'Flutter Developer',
          freelancerImageUrl: 'https://i.pravatar.cc/150?img=8',
          freelancerRating: 4.5,
          matchPercentage: 76,
          coverLetter: 'I can do this job. I have made 10+ flutter apps. Check my portfolio. I will do it fast and cheap.',
          bidAmount: 800.0,
          estimatedDays: 7,
          submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

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
