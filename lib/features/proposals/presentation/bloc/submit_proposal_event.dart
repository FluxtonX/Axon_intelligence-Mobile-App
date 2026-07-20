import 'package:equatable/equatable.dart';

abstract class SubmitProposalEvent extends Equatable {
  const SubmitProposalEvent();

  @override
  List<Object> get props => [];
}

class SubmitProposalRequested extends SubmitProposalEvent {
  final String projectId;
  final double bidAmount;
  final int deliveryDays;
  final String coverLetter;

  const SubmitProposalRequested({
    required this.projectId,
    required this.bidAmount,
    required this.deliveryDays,
    required this.coverLetter,
  });

  @override
  List<Object> get props => [projectId, bidAmount, deliveryDays, coverLetter];
}
