import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';
import '../../../proposals/domain/entities/proposal_entity.dart';

abstract class HireEvent extends Equatable {
  const HireEvent();

  @override
  List<Object?> get props => [];
}

class HireInitialize extends HireEvent {
  final ProposalEntity proposal;

  const HireInitialize({
    required this.proposal,
  });

  @override
  List<Object?> get props => [proposal];
}

class HireAcceptProposal extends HireEvent {
  const HireAcceptProposal();
}

class HireProcessPayment extends HireEvent {
  const HireProcessPayment();
}

class HireCreateDirectContract extends HireEvent {
  final String freelancerId;
  final String title;
  final String description;
  final double amount;
  final int deliveryDays;

  const HireCreateDirectContract({
    required this.freelancerId,
    required this.title,
    required this.description,
    required this.amount,
    required this.deliveryDays,
  });

  @override
  List<Object?> get props => [freelancerId, title, description, amount, deliveryDays];
}
