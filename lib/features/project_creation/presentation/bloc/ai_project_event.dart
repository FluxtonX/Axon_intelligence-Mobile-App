import 'package:equatable/equatable.dart';

abstract class AiProjectEvent extends Equatable {
  const AiProjectEvent();

  @override
  List<Object?> get props => [];
}

class AiProjectStarted extends AiProjectEvent {
  const AiProjectStarted();
}

class UserMessageSubmitted extends AiProjectEvent {
  const UserMessageSubmitted(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

class OptionSelected extends AiProjectEvent {
  const OptionSelected(this.optionText);
  final String optionText;

  @override
  List<Object?> get props => [optionText];
}
