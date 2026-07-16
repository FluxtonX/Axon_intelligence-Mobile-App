import 'package:equatable/equatable.dart';

abstract class EmailAuthEvent extends Equatable {
  const EmailAuthEvent();
  @override
  List<Object?> get props => [];
}

class EmailAuthModeToggled extends EmailAuthEvent {
  const EmailAuthModeToggled({required this.isLogin});
  final bool isLogin;
  @override
  List<Object?> get props => [isLogin];
}

class EmailAuthSubmitted extends EmailAuthEvent {
  const EmailAuthSubmitted({
    required this.email,
    required this.password,
    this.name,
  });

  final String email;
  final String password;
  final String? name; // Only used for registration

  @override
  List<Object?> get props => [email, password, name];
}

class EmailAuthForgotPasswordSubmitted extends EmailAuthEvent {
  const EmailAuthForgotPasswordSubmitted({required this.email});
  
  final String email;
  
  @override
  List<Object?> get props => [email];
}

class EmailAuthResetPasswordSubmitted extends EmailAuthEvent {
  const EmailAuthResetPasswordSubmitted({
    required this.token,
    required this.newPassword,
  });
  
  final String token;
  final String newPassword;
  
  @override
  List<Object?> get props => [token, newPassword];
}
