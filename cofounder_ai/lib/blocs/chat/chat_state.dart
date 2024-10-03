import '../../models/chat_message.dart';

enum ChatStatus { initial, loading, success, error }

class ChatState {
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;
  final bool isAiTyping;

  ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
    this.isAiTyping = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
    bool? isAiTyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isAiTyping: isAiTyping ?? this.isAiTyping,
    );
  }
}
