import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/hire_repository.dart';
import 'hire_event.dart';
import 'hire_state.dart';

@injectable
class HireBloc extends Bloc<HireEvent, HireState> {
  final HireRepository _repository;
  final _uuid = const Uuid();

  HireBloc(this._repository) : super(const HireState()) {
    on<HireInitialize>(_onInitialize);
    on<HireAddMilestone>(_onAddMilestone);
    on<HireRemoveMilestone>(_onRemoveMilestone);
    on<HireCreateContract>(_onCreateContract);
    on<HireProcessPayment>(_onProcessPayment);
  }

  void _onInitialize(HireInitialize event, Emitter<HireState> emit) {
    emit(state.copyWith(
      freelancerId: event.freelancerId,
      freelancerName: event.freelancerName,
      status: HireStatus.initial,
      milestones: [],
      contract: null,
    ));
  }

  void _onAddMilestone(HireAddMilestone event, Emitter<HireState> emit) {
    final newMilestone = MilestoneEntity(
      id: _uuid.v4(),
      title: event.title,
      description: event.description,
      amount: event.amount,
    );

    final updatedMilestones = List<MilestoneEntity>.from(state.milestones)
      ..add(newMilestone);

    emit(state.copyWith(milestones: updatedMilestones));
  }

  void _onRemoveMilestone(HireRemoveMilestone event, Emitter<HireState> emit) {
    final updatedMilestones = state.milestones
        .where((m) => m.id != event.milestoneId)
        .toList();

    emit(state.copyWith(milestones: updatedMilestones));
  }

  Future<void> _onCreateContract(
    HireCreateContract event,
    Emitter<HireState> emit,
  ) async {
    if (state.milestones.isEmpty) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Please add at least one milestone.',
      ));
      return;
    }

    emit(state.copyWith(status: HireStatus.loading));

    try {
      final contract = await _repository.createContract(
        freelancerId: state.freelancerId,
        buyerId: 'current_buyer_id', // Would come from AuthBloc
        title: event.title,
        milestones: state.milestones,
        totalAmount: state.totalAmount,
      );

      emit(state.copyWith(
        status: HireStatus.contractCreated,
        contract: contract,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'Failed to create contract. Please try again.',
      ));
    }
  }

  Future<void> _onProcessPayment(
    HireProcessPayment event,
    Emitter<HireState> emit,
  ) async {
    if (state.contract == null) return;

    emit(state.copyWith(status: HireStatus.paymentProcessing));

    try {
      final success = await _repository.processPayment(
        state.contract!.id,
        state.totalAmount,
      );

      if (success) {
        emit(state.copyWith(status: HireStatus.paymentSuccess));
      } else {
        emit(state.copyWith(
          status: HireStatus.error,
          errorMessage: 'Payment failed. Please check your card details.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: HireStatus.error,
        errorMessage: 'An error occurred during payment.',
      ));
    }
  }
}
