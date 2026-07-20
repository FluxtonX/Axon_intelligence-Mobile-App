import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/chat_message.dart';
import 'ai_project_event.dart';
import 'ai_project_state.dart';
import '../../data/repositories/ai_project_repository.dart';

class AiProjectBloc extends Bloc<AiProjectEvent, AiProjectState> {
  final AiProjectRepository _repository;

  AiProjectBloc(this._repository) : super(const AiProjectState()) {
    on<AiProjectStarted>(_onStarted);
    on<UserMessageSubmitted>(_onUserMessageSubmitted);
    on<OptionSelected>(_onOptionSelected);
  }

  final _uuid = const Uuid();
  int _step = 0; // Tracks conversational progress

  Future<void> _onStarted(AiProjectStarted event, Emitter<AiProjectState> emit) async {
    // Initial greeting
    emit(state.copyWith(status: ProjectCreationStatus.typing));
    await Future.delayed(const Duration(milliseconds: 800));

    emit(state.copyWith(
      messages: [
        ChatMessage(
          id: _uuid.v4(),
          type: ChatMessageType.ai,
          text: "✨ Tell Axon what you're looking for. I'll help you build a complete project brief.",
        ),
      ],
      status: ProjectCreationStatus.waitingForInput,
    ));
  }

  Future<void> _onUserMessageSubmitted(UserMessageSubmitted event, Emitter<AiProjectState> emit) async {
    await _handleUserReply(event.text, emit);
  }

  Future<void> _onOptionSelected(OptionSelected event, Emitter<AiProjectState> emit) async {
    await _handleUserReply(event.optionText, emit);
  }

  Future<void> _handleUserReply(String text, Emitter<AiProjectState> emit) async {
    // 1. Add user message
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      type: ChatMessageType.user,
      text: text,
    );
    
    emit(state.copyWith(
      messages: List.of(state.messages)..add(userMsg),
      status: ProjectCreationStatus.typing,
    ));

    // 2. Call backend instead of mock thinking time
    try {
      final response = await _repository.sendChatMessage(_step, text);
      
      _step++;
      
      final String aiText = response['text'] ?? '';
      final List<dynamic>? rawOptions = response['options'];
      final List<String>? aiOptions = rawOptions?.map((e) => e.toString()).toList();
      final String apiStatus = response['status'] ?? 'waitingForInput';
      
      final aiReply = ChatMessage(
        id: _uuid.v4(),
        type: ChatMessageType.ai,
        text: aiText,
        options: aiOptions ?? [],
      );

      if (apiStatus == 'complete') {
        emit(state.copyWith(
          messages: List.of(state.messages)..add(aiReply),
          status: ProjectCreationStatus.generatingBrief,
        ));
        
        // Simulating the brief generation loading state slightly for UX
        await Future.delayed(const Duration(milliseconds: 1500));
        
        emit(state.copyWith(
          status: ProjectCreationStatus.complete,
          // we could store the generatedBrief in state here if needed
        ));
      } else {
        emit(state.copyWith(
          messages: List.of(state.messages)..add(aiReply),
          status: ProjectCreationStatus.waitingForInput,
        ));
      }
    } catch (e) {
      // In case of error, just fallback to waiting
      emit(state.copyWith(
        status: ProjectCreationStatus.waitingForInput,
      ));
    }
  }
}
