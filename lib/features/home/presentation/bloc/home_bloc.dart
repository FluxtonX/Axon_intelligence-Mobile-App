import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeDataFetched>(_onDataFetched);
    on<HomeDebugStateToggled>(_onDebugStateToggled);
  }

  Future<void> _onDataFetched(
    HomeDataFetched event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // For development, we default to the Active state
    emit(state.copyWith(status: HomeStatus.active));
  }

  void _onDebugStateToggled(
    HomeDebugStateToggled event,
    Emitter<HomeState> emit,
  ) {
    if (state.status == HomeStatus.active) {
      emit(state.copyWith(status: HomeStatus.empty));
    } else {
      emit(state.copyWith(status: HomeStatus.active));
    }
  }
}
