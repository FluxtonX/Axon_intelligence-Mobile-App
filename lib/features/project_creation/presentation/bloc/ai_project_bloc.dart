import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/chat_message.dart';
import 'ai_project_event.dart';
import 'ai_project_state.dart';

class AiProjectBloc extends Bloc<AiProjectEvent, AiProjectState> {
  AiProjectBloc() : super(const AiProjectState()) {
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

    // 2. Mock AI thinking time
    await Future.delayed(const Duration(milliseconds: 1200));

    // 3. Determine next AI response based on step
    _step++;
    ChatMessage aiReply;
    
    if (_step == 1) {
      aiReply = ChatMessage(
        id: _uuid.v4(),
        type: ChatMessageType.ai,
        text: "Got it! What's your estimated budget for this project?",
        options: const ["<\$500", "\$500 - \$2000", "\$2000+"],
      );
      emit(state.copyWith(
        messages: List.of(state.messages)..add(aiReply),
        status: ProjectCreationStatus.waitingForInput,
      ));
    } else if (_step == 2) {
      aiReply = ChatMessage(
        id: _uuid.v4(),
        type: ChatMessageType.ai,
        text: "Understood. When do you need this delivered?",
        options: const ["ASAP", "1 Week", "1 Month"],
      );
      emit(state.copyWith(
        messages: List.of(state.messages)..add(aiReply),
        status: ProjectCreationStatus.waitingForInput,
      ));
    } else if (_step == 3) {
      aiReply = ChatMessage(
        id: _uuid.v4(),
        type: ChatMessageType.ai,
        text: "Perfect. Any specific skills or frameworks the freelancer must know? (e.g., Flutter, Node.js)",
        options: const ["Flutter & Firebase", "React Native", "Native iOS/Android", "Not sure, you decide"],
      );
      emit(state.copyWith(
        messages: List.of(state.messages)..add(aiReply),
        status: ProjectCreationStatus.waitingForInput,
      ));
    } else {
      // End of flow, start generating brief
      emit(state.copyWith(status: ProjectCreationStatus.generatingBrief));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ProjectCreationStatus.complete));
    }
  }
}
