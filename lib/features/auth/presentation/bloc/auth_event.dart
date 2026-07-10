import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class EmailSignInRequested extends AuthEvent {
  const EmailSignInRequested();
}

class GuestBrowsingRequested extends AuthEvent {
  const GuestBrowsingRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
