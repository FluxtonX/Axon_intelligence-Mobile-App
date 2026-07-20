import 'package:equatable/equatable.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchChatHistory extends ChatDetailEvent {
  final String otherUserId;

  const FetchChatHistory(this.otherUserId);

  @override
  List<Object> get props => [otherUserId];
}

class SendMessage extends ChatDetailEvent {
  final String otherUserId;
  final String content;

  const SendMessage({required this.otherUserId, required this.content});

  @override
  List<Object> get props => [otherUserId, content];
}
