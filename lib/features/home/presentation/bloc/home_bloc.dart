import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(const HomeState()) {
    on<HomeDataFetched>(_onDataFetched);
    on<HomeDebugStateToggled>(_onDebugStateToggled);
  }

  Future<void> _onDataFetched(
    HomeDataFetched event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      final dashboardData = await _homeRepository.getClientDashboard();
      
      final nextStatus = dashboardData.stats.totalHires > 0 || dashboardData.stats.activeContracts > 0
          ? HomeStatus.active
          : HomeStatus.empty;

      emit(state.copyWith(
        status: nextStatus,
        dashboardData: dashboardData,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to load dashboard data: $e',
      ));
    }
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
