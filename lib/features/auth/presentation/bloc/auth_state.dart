import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Initial idle state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Google sign-in in progress
class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading();
}

/// Email flow triggered — navigate to email screen
class AuthEmailFlowStarted extends AuthState {
  const AuthEmailFlowStarted();
}

/// Guest mode activated
class AuthGuestMode extends AuthState {
  const AuthGuestMode();
}

/// Auth succeeded — navigate to home
class AuthSuccess extends AuthState {
  const AuthSuccess();
}

/// Auth failed
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// User signed out — navigate back to Auth
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
