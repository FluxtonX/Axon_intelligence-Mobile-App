import 'package:equatable/equatable.dart';

enum ConversationsStatus { initial, loading, success, failure }

class ConversationsState extends Equatable {
  final ConversationsStatus status;
  final List<dynamic> conversations;
  final String? errorMessage;

  const ConversationsState({
    this.status = ConversationsStatus.initial,
    this.conversations = const [],
    this.errorMessage,
  });

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<dynamic>? conversations,
    String? errorMessage,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, conversations, errorMessage];
}
