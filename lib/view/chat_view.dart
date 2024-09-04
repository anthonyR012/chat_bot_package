import 'package:chat_bot/controllers/interfaces/chat_controller_interface.dart';
import 'package:chat_bot/view/views/chat_bubble.dart';
import 'package:chat_bot/view/views/chat_input_field.dart';
import 'package:chat_bot/view/views/typing_indicator.dart';
import 'package:flutter/material.dart';

/// ChatBot is a widget that displays a chat interface.
/// It allows you to handle communication between two users or with ChatGPT.
class ChatBot extends StatefulWidget {
  /// You must provide a ChatController to use this widget.
  const ChatBot(
      {super.key,
      required this.chatController,
      this.customTypeIndicator,
      this.styleTextHourBubble,
      this.styleSentByMeBubble,
      this.styleReceivedByMeBubble,
      this.styleInput});

  /// Controller for the chat bot, you can use any implementation instead of ApiDatasource default
  final ChatControllerInterface chatController;

  /// The widget that will be displayed when the user is typing.
  /// For default behavior, set it to null.
  final Widget? customTypeIndicator;

  /// bubble subtitle (time and date) style
  final TextStyle? styleTextHourBubble;

  /// bubble style sent by me
  final StyleSentByMe? styleSentByMeBubble;

  /// bubble style received by me
  final StyleReceivedByMe? styleReceivedByMeBubble;

  /// input style of the chat
  final ChatInputStyle? styleInput;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late final ChatControllerInterface _chatController;

  @override
  void initState() {
    _chatController = widget.chatController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenableBuilder(
              listenable: _chatController,
              builder: (context, snapshot) {
                bool isLoading = _chatController.isLoading;
                final messages = _chatController.messages;
                return Expanded(
                  child: ListView.builder(
                    key: const Key('chat_list_view'),
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
          ChatTextField(
            controller: _chatController.textEditingController,
            onSend: _chatController.sendMessage,
            focus: _chatController.focusNode,
            style: widget.styleInput,
            key: const Key('chat_input_field'),
          ),
        ],
      ),
    );
  }
}
