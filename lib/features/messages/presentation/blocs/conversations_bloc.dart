import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../data/repositories/messages_repository.dart';
import 'conversations_event.dart';
import 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final MessagesRepository _messagesRepository;
  StreamSubscription? _messageSubscription;

  ConversationsBloc(this._messagesRepository) : super(const ConversationsState()) {
    on<FetchConversations>(_onFetchConversations);
    
    // Initialize socket connection and listen to incoming real-time messages
    _messagesRepository.initializeSocket();
    _messageSubscription = _messagesRepository.incomingMessages.listen((message) {
      // Refresh the conversations list when a new message arrives
      add(const FetchConversations());
    });
  }

  Future<void> _onFetchConversations(FetchConversations event, Emitter<ConversationsState> emit) async {
    emit(state.copyWith(status: ConversationsStatus.loading));
    try {
      final conversations = await _messagesRepository.getConversations();
      emit(state.copyWith(
        status: ConversationsStatus.success,
        conversations: conversations,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConversationsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
