import 'package:equatable/equatable.dart';
import '../../domain/models/chat_message.dart';

enum ProjectCreationStatus { typing, waitingForInput, generatingBrief, complete }

class AiProjectState extends Equatable {
  const AiProjectState({
    this.messages = const [],
    this.status = ProjectCreationStatus.typing,
  });

  final List<ChatMessage> messages;
  final ProjectCreationStatus status;

  AiProjectState copyWith({
    List<ChatMessage>? messages,
    ProjectCreationStatus? status,
  }) {
    return AiProjectState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [messages, status];
}
