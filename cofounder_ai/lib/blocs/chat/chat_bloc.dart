import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../models/chat_message.dart';
import 'chat_state.dart';

class ChatBloc extends Cubit<ChatState> {
  ChatBloc() : super(ChatState());

  static const apikey = "AIzaSyD_oL-0jXjJ3qgQsJ7lzah-fs6p5j2PMtE";

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apikey,
  );
  late ChatSession _chat;

  void initChat() {
    try {
      _chat = _model.startChat(
        history: [
          Content('User', [TextPart('Hello')]),
          Content('model', [
            TextPart(
                'Great to meet you. What would you like to brainstorm about your startup or business?')
          ])
        ],
      );
      emit(state.copyWith(
        messages: [
          ChatMessage(
              sender: 'AI',
              text:
                  'Great to meet you. What would you like to brainstorm about your startup or business?')
        ],
        status: ChatStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to initialize chat: ${e.toString()}',
      ));
    }
  }

  Future<void> sendMessage(String message) async {
    final currentState = state;
    emit(state.copyWith(
      messages: [
        ...currentState.messages,
        ChatMessage(sender: 'User', text: message)
      ],
      isAiTyping: true,
    ));

    try {
      final response =
          await _chat.sendMessage(Content('user', [TextPart(message)]));
      final aiMessage = response.text;

      emit(state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
              sender: 'AI', text: aiMessage ?? 'oops something went wrong hehe')
        ],
        isAiTyping: false,
        status: ChatStatus.success,
      ));

      // Store the conversation in Firestore
      await FirebaseFirestore.instance.collection('conversations').add({
        'user_message': message,
        'ai_response': aiMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(state.copyWith(
        isAiTyping: false,
        status: ChatStatus.error,
        errorMessage: 'Failed to send message: ${e.toString()}',
      ));
    }
  }
}
