import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/view/views/chat_bubble.dart';
import 'package:chat_bot/view/views/chat_input_field.dart';
import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/view/views/typing_indicator.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key, required this.chatController});
  final ChatController chatController;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _textEditingController = TextEditingController();

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
                        return const TypingIndicator();
                      }
                      return ChatBubble(message: messages[index]);
                    },
                  ),
                );
              }),
          const Divider(height: 1),
          ChatInputField(
            controller: _textEditingController,
            onSend: _onSendMessage,
          ),
        ],
      ),
    );
  }

  void _onSendMessage([String? messageDefault]) {
    String message = messageDefault ?? _textEditingController.text;
    if (message.isEmpty) return;
    _chatController.messages.add(ChatMessageModel(
      isSentByMe: true,
      created: _chatController.getCurrentHour(),
      choices: [
        ChoiceModel(
          message: MessageModel(
            content: message,
            role: "user",
          ),
        )
      ],
    ));
    _chatController.scrollToEnd();
    _chatController.sendMessage(message);
    _textEditingController.clear();
  }


}
