import 'package:equatable/equatable.dart';

class EmailAuthState extends Equatable {
  const EmailAuthState({
    this.isLogin = true, // Default to Login view
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.isSuccess = false,
  });

  final bool isLogin;
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final bool isSuccess;

  EmailAuthState copyWith({
    bool? isLogin,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? isSuccess,
  }) {
    return EmailAuthState(
      isLogin: isLogin ?? this.isLogin,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Allow nulling out error
      successMessage: successMessage, // Allow nulling out successMessage
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLogin, isLoading, error, successMessage, isSuccess];
}
