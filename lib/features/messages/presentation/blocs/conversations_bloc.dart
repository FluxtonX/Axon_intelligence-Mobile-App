import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/messages_repository.dart';
import 'conversations_event.dart';
import 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final MessagesRepository _messagesRepository;

  ConversationsBloc(this._messagesRepository) : super(const ConversationsState()) {
    on<FetchConversations>(_onFetchConversations);
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
}
