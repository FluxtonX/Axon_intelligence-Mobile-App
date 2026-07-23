import 'package:flutter_bloc/flutter_bloc.dart';
import 'services_event.dart';
import 'services_state.dart';
import '../../data/repositories/services_repository.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _servicesRepository;
  static const int _take = 20;

  ServicesBloc(this._servicesRepository) : super(ServicesInitial()) {
    on<LoadServices>(_onLoadServices);
    on<LoadMyServices>(_onLoadMyServices);
    on<CreateService>(_onCreateService);
  }

  Future<void> _onLoadServices(LoadServices event, Emitter<ServicesState> emit) async {
    try {
      if (state is ServicesInitial || event.refresh) {
        emit(ServicesLoading());
        final services = await _servicesRepository.getServices(
          query: event.query,
          skip: 0,
          take: _take,
        );
        emit(ServicesLoaded(
          services: services,
          hasReachedMax: services.length < _take,
        ));
        return;
      }

      if (state is ServicesLoaded) {
        final currentState = state as ServicesLoaded;
        if (currentState.hasReachedMax) return;

        final services = await _servicesRepository.getServices(
          query: event.query,
          skip: currentState.services.length,
          take: _take,
        );

        emit(services.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : ServicesLoaded(
                services: currentState.services + services,
                hasReachedMax: services.length < _take,
              ));
      }
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> _onLoadMyServices(LoadMyServices event, Emitter<ServicesState> emit) async {
    try {
      emit(ServicesLoading());
      final services = await _servicesRepository.getMyServices();
      emit(ServicesLoaded(
        services: services,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> _onCreateService(CreateService event, Emitter<ServicesState> emit) async {
    try {
      emit(ServiceCreating());
      final service = await _servicesRepository.createService(
        title: event.title,
        category: event.category,
        description: event.description,
        price: event.price,
        deliveryDays: event.deliveryDays,
        imageUrl: event.imageUrl,
      );
      emit(ServiceCreated(service));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
