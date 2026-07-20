import 'package:equatable/equatable.dart';

import '../../../../core/models/user_model.dart';

abstract class AuthState extends Equatable {
  final UserModel? user;
  const AuthState({this.user});
  @override
  List<Object?> get props => [user];
}

/// Initial idle state
class AuthInitial extends AuthState {
  const AuthInitial({super.user});
}

/// Google sign-in in progress
class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading({super.user});
}

/// Email flow triggered — navigate to email screen
class AuthEmailFlowStarted extends AuthState {
  const AuthEmailFlowStarted({super.user});
}

/// Guest mode activated
class AuthGuestMode extends AuthState {
  const AuthGuestMode({super.user});
}

/// Auth succeeded — navigate to home
class AuthSuccess extends AuthState {
  const AuthSuccess({super.user});
}

/// Auth failed
class AuthError extends AuthState {
  const AuthError(this.message, {super.user});
  final String message;
  @override
  List<Object?> get props => [message, user];
}

/// User signed out — navigate back to Auth
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({super.user});
}
