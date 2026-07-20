import 'package:equatable/equatable.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();

  @override
  List<Object> get props => [];
}

class FetchConversations extends ConversationsEvent {
  const FetchConversations();
}
