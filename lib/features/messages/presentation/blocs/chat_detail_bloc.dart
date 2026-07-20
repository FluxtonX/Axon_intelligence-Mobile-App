import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/messages_repository.dart';
import 'chat_detail_event.dart';
import 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final MessagesRepository _messagesRepository;

  ChatDetailBloc(this._messagesRepository) : super(const ChatDetailState()) {
    on<FetchChatHistory>(_onFetchChatHistory);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onFetchChatHistory(FetchChatHistory event, Emitter<ChatDetailState> emit) async {
    emit(state.copyWith(status: ChatDetailStatus.loading));
    try {
      final response = await _messagesRepository.getConversation(event.otherUserId);
      emit(state.copyWith(
        status: ChatDetailStatus.success,
        messages: response['data'], // Assuming the backend returns { data: [...], meta: ... }
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatDetailState> emit) async {
    try {
      await _messagesRepository.sendMessage(event.otherUserId, event.content);
      // Re-fetch to get the newly added message. A real app might append optimistically.
      add(FetchChatHistory(event.otherUserId));
    } catch (e) {
      // Could emit an error state here, but ignoring for simplicity or handle via UI
      emit(state.copyWith(
        status: ChatDetailStatus.failure,
        errorMessage: 'Failed to send message',
      ));
    }
  }
}
