import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_auth_event.dart';
import 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  EmailAuthBloc() : super(const EmailAuthState()) {
    on<EmailAuthModeToggled>(_onModeToggled);
    on<EmailAuthSubmitted>(_onSubmitted);
  }



  void _onModeToggled(
    EmailAuthModeToggled event,
    Emitter<EmailAuthState> emit,
  ) {
    emit(state.copyWith(
      isLogin: event.isLogin,
      error: null, // Clear errors when toggling modes
    ));
  }

  Future<void> _onSubmitted(
    EmailAuthSubmitted event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Simulate backend authentication delay
      await Future.delayed(const Duration(seconds: 1));

      // Simple mock validation
      if (event.password.length < 6) {
        emit(state.copyWith(isLoading: false, error: 'Password must be at least 6 characters.'));
        return;
      }
      
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'An unexpected error occurred.'));
    }
  }
}
