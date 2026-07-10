import 'package:equatable/equatable.dart';

enum HomeStatus { loading, empty, active, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.errorMessage,
  });

  final HomeStatus status;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
