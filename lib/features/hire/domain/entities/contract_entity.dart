import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime? deadline;

  const MilestoneEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    this.deadline,
  });

  @override
  List<Object?> get props => [id, title, description, amount, deadline];
}

class ContractEntity extends Equatable {
  final String id;
  final String freelancerId;
  final String buyerId;
  final String title;
  final List<MilestoneEntity> milestones;
  final double totalAmount;
  final DateTime createdAt;
  final String status; // e.g., 'pending', 'active', 'completed'

  const ContractEntity({
    required this.id,
    required this.freelancerId,
    required this.buyerId,
    required this.title,
    required this.milestones,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        freelancerId,
        buyerId,
        title,
        milestones,
        totalAmount,
        createdAt,
        status,
      ];
}
