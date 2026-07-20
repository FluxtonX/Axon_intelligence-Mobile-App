import 'package:equatable/equatable.dart';

enum ChatDetailStatus { initial, loading, success, failure }

class ChatDetailState extends Equatable {
  final ChatDetailStatus status;
  final List<dynamic> messages;
  final String? errorMessage;

  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  ChatDetailState copyWith({
    ChatDetailStatus? status,
    List<dynamic>? messages,
    String? errorMessage,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
