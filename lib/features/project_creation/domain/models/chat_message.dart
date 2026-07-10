import 'package:equatable/equatable.dart';

enum ChatMessageType { user, ai, typing }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.type,
    this.text = '',
    this.options = const [],
  });

  final String id;
  final ChatMessageType type;
  final String text;
  
  /// Selectable options (e.g., budget ranges, timeline) presented by the AI
  final List<String> options;

  bool get isUser => type == ChatMessageType.user;
  bool get isAi => type == ChatMessageType.ai;
  bool get isTyping => type == ChatMessageType.typing;

  @override
  List<Object?> get props => [id, type, text, options];
}
