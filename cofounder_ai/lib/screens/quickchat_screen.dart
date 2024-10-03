import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_state.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';
import 'widgets/typing_indicator.dart';

class QuickChatScreen extends StatelessWidget {
  const QuickChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..initChat(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Chat'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state.status == ChatStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage ?? 'An error occurred')),
              );
            }
          },
          builder: (context, state) {
            if (state.status == ChatStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: state.messages[index]);
                    },
                  ),
                ),
                if (state.isAiTyping) const TypingIndicator(),
                const MessageInput(),
              ],
            );
          },
        ),
      ),
    );
  }
}
