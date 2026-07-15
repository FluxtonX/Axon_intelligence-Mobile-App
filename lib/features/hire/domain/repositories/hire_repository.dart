import '../entities/contract_entity.dart';

abstract class HireRepository {
  /// Create a new contract with milestones
  Future<ContractEntity> createContract({
    required String freelancerId,
    required String buyerId,
    required String title,
    required List<MilestoneEntity> milestones,
    required double totalAmount,
  });

  /// Process the payment/escrow for the contract
  Future<bool> processPayment(String contractId, double amount);
}
