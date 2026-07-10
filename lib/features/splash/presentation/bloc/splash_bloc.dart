import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Wait for splash animation to complete
    await Future.delayed(AppConstants.splashDuration);

    // TODO: Check auth session (SharedPreferences / secure storage)
    // For now, always navigate to auth
    emit(const SplashNavigateToAuth());
  }
}
