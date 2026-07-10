import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_auth_event.dart';
import 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  EmailAuthBloc() : super(const EmailAuthState()) {
    on<EmailAuthModeToggled>(_onModeToggled);
    on<EmailAuthSubmitted>(_onSubmitted);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        // Log in flow
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
      } else {
        // Registration flow
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
        
        // Update display name if provided
        if (event.name != null && event.name!.trim().isNotEmpty) {
          await userCredential.user?.updateDisplayName(event.name!.trim());
        }
      }
      
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An authentication error occurred.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists with this email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak. Please use at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      }
      
      emit(state.copyWith(isLoading: false, error: errorMessage));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'An unexpected error occurred.'));
    }
  }
}
