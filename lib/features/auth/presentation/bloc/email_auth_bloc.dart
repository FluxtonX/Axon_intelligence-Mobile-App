import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_auth_event.dart';
import 'email_auth_state.dart';

import '../../data/auth_repository.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final AuthRepository _authRepository;

  EmailAuthBloc(this._authRepository) : super(const EmailAuthState()) {
    on<EmailAuthModeToggled>(_onModeToggled);
    on<EmailAuthSubmitted>(_onSubmitted);
    on<EmailAuthForgotPasswordSubmitted>(_onForgotPassword);
    on<EmailAuthResetPasswordSubmitted>(_onResetPassword);
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
      if (state.isLogin) {
        await _authRepository.login(event.email, event.password);
      } else {
        await _authRepository.register(
          event.email,
          event.password,
          event.name ?? 'User',
        );
      }
      
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false, 
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onForgotPassword(
    EmailAuthForgotPasswordSubmitted event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    try {
      final message = await _authRepository.forgotPassword(event.email);
      emit(state.copyWith(isLoading: false, successMessage: message)); 
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onResetPassword(
    EmailAuthResetPasswordSubmitted event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    try {
      await _authRepository.resetPassword(event.token, event.newPassword);
      emit(state.copyWith(isLoading: false, successMessage: 'Password successfully reset! You can now log in.'));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
