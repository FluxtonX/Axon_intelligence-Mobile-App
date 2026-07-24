import 'package:equatable/equatable.dart';

abstract class SellerOnboardingState extends Equatable {
  const SellerOnboardingState();

  @override
  List<Object?> get props => [];
}

class SellerOnboardingInitial extends SellerOnboardingState {}

class SellerOnboardingLoading extends SellerOnboardingState {}

class SellerOnboardingSuccess extends SellerOnboardingState {}

class SellerOnboardingFailure extends SellerOnboardingState {
  final String error;

  const SellerOnboardingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
