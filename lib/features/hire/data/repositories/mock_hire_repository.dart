import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/hire_repository.dart';

@Injectable(as: HireRepository)
class MockHireRepository implements HireRepository {
  final _uuid = const Uuid();

  @override
  Future<ContractEntity> createContract({
    required String freelancerId,
    required String buyerId,
    required String title,
    required List<MilestoneEntity> milestones,
    required double totalAmount,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return ContractEntity(
      id: _uuid.v4(),
      freelancerId: freelancerId,
      buyerId: buyerId,
      title: title,
      milestones: milestones,
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      status: 'pending_payment',
    );
  }


  @override
  Future<bool> processPayment(String contractId, double amount) async {
    // Simulate payment processing delay (calling Stripe/Escrow)
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    return true;
  }
}
