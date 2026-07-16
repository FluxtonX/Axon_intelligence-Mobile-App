
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<EmailSignInRequested>(_onEmailSignIn);
    on<GuestBrowsingRequested>(_onGuestBrowsing);
    on<SignOutRequested>(_onSignOut);
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthGoogleLoading());
    try {
      // Force the account picker to show every time by signing out first
      await _googleSignIn.signOut();
      
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // User cancelled the sign-in
        emit(const AuthInitial());
        return;
      }
      // Simulate backend authentication with Google credentials
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onEmailSignIn(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) {
    // Triggers navigation to email login/register screen
    emit(const AuthEmailFlowStarted());
  }

  void _onGuestBrowsing(
    GuestBrowsingRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthGuestMode());
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _googleSignIn.signOut();
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
