import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;
  final bool hasReachedMax;

  const ServicesLoaded({
    required this.services,
    this.hasReachedMax = false,
  });

  ServicesLoaded copyWith({
    List<ServiceEntity>? services,
    bool? hasReachedMax,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [services, hasReachedMax];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}

// State for Service Creation
class ServiceCreating extends ServicesState {}

class ServiceCreated extends ServicesState {
  final ServiceEntity service;

  const ServiceCreated(this.service);

  @override
  List<Object?> get props => [service];
}
