import 'package:cofounder_ai/screens/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/chat_bloc.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your messages...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && !_animationController.isCompleted) {
                  _animationController.forward();
                } else if (value.isEmpty && _animationController.isCompleted) {
                  _animationController.reverse();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          PulsingFAB(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                context.read<ChatBloc>().sendMessage(_controller.text);
                _controller.clear();
                _animationController.reverse();
              }
            },
            message: true,
          )
        ],
      ),
    );
  }
}
