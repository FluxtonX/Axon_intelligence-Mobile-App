import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_entity.dart';

abstract class HireEvent extends Equatable {
  const HireEvent();

  @override
  List<Object?> get props => [];
}

class HireInitialize extends HireEvent {
  final String freelancerId;
  final String freelancerName;

  const HireInitialize({
    required this.freelancerId,
    required this.freelancerName,
  });

  @override
  List<Object?> get props => [freelancerId, freelancerName];
}

class HireAddMilestone extends HireEvent {
  final String title;
  final String description;
  final double amount;

  const HireAddMilestone({
    required this.title,
    required this.description,
    required this.amount,
  });

  @override
  List<Object?> get props => [title, description, amount];
}

class HireRemoveMilestone extends HireEvent {
  final String milestoneId;

  const HireRemoveMilestone(this.milestoneId);

  @override
  List<Object?> get props => [milestoneId];
}

class HireCreateContract extends HireEvent {
  final String title;

  const HireCreateContract({required this.title});

  @override
  List<Object?> get props => [title];
}

class HireProcessPayment extends HireEvent {
  const HireProcessPayment();
}
