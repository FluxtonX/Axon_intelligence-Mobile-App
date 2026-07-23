import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/auth/data/auth_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository? _authRepository;

  SplashBloc([this._authRepository]) : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Wait for splash animation to complete
    await Future.delayed(AppConstants.splashDuration);

    if (_authRepository != null && _authRepository.isLoggedIn()) {
      emit(const SplashNavigateToHome());
    } else {
      emit(const SplashNavigateToAuth());
    }
  }
}
