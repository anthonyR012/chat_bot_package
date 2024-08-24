import 'package:chat_bot/view/views/chat_bubble.dart';
import 'package:chat_bot/view/views/chat_input_field.dart';
import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/view/views/typing_indicator.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot(
      {super.key,
      required this.chatController,
      this.customTypeIndicator,
      this.styleTextHourBubble,
      this.styleSentByMeBubble,
      this.styleReceivedByMeBubble,
      this.styleInput});

  final ChatController chatController;

  /// The widget that will be displayed when the user is typing.
  /// For default behavior, set it to null.
  final Widget? customTypeIndicator;

  /// bubble style
  final TextStyle? styleTextHourBubble;
  final StyleSentByMe? styleSentByMeBubble;
  final StyleReceivedByMe? styleReceivedByMeBubble;

  final ChatInputStyle? styleInput;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late final ChatController _chatController;

  @override
  void initState() {
    _chatController = widget.chatController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenableBuilder(
              listenable: _chatController,
              builder: (context, snapshot) {
                bool isLoading = _chatController.isLoading;
                final messages = _chatController.messages;
                return Expanded(
                  child: ListView.builder(
                    controller: _chatController.scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return widget.customTypeIndicator ??
                            const TypingIndicator();
                      }
                      return ChatBubble(
                        message: messages[index],
                        styleReceivedByMe: widget.styleReceivedByMeBubble,
                        styleSentByMe: widget.styleSentByMeBubble,
                        styleTextHour: widget.styleTextHourBubble,
                      );
                    },
                  ),
                );
              }),
          const Divider(height: 1),
          ChatInputField(
            controller: _chatController.textEditingController,
            onSend: _chatController.sendMessage,
            style: widget.styleInput,
          ),
        ],
      ),
    );
  }
}
