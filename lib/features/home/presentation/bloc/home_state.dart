import 'package:equatable/equatable.dart';
import '../../data/models/dashboard_data_model.dart';

enum HomeStatus { loading, empty, active, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.errorMessage,
    this.dashboardData,
  });

  final HomeStatus status;
  final String? errorMessage;
  final DashboardDataModel? dashboardData;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    DashboardDataModel? dashboardData,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, dashboardData];
}
