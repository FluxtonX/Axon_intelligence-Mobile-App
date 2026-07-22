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
      final List<dynamic> messageList = response['messages'] ?? response['data'] ?? [];
      emit(state.copyWith(
        status: ChatDetailStatus.success,
        messages: messageList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatDetailState> emit) async {
    final senderId = event.senderRole == 'freelancer' ? 'freelancer_me' : 'client_user_me';
    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'senderId': senderId,
      'content': event.content,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final updatedMessages = List<dynamic>.from(state.messages)..insert(0, newMessage);
    emit(state.copyWith(
      status: ChatDetailStatus.success,
      messages: updatedMessages,
    ));

    try {
      await _messagesRepository.sendMessage(
        event.otherUserId,
        event.content,
        senderRole: event.senderRole,
      );
    } catch (e) {
      // Keep optimistic message displayed for UI feedback
    }
  }
}
