import 'package:equatable/equatable.dart';

class EmailAuthState extends Equatable {
  const EmailAuthState({
    this.isLogin = true, // Default to Login view
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  final bool isLogin;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  EmailAuthState copyWith({
    bool? isLogin,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return EmailAuthState(
      isLogin: isLogin ?? this.isLogin,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Allow nulling out error
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLogin, isLoading, error, isSuccess];
}
