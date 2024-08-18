import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});
  static const String routeName = 'help';

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatViewModel _chatViewModel = ChatViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenableBuilder(listenable:  _chatViewModel,
          builder: (context, snapshot) {
            bool isLoading = _chatViewModel.isLoading;
            final messages = _chatViewModel.messages;
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
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
    _chatViewModel.messages.add(ChatMessageModel(
      isSentByMe: true,
      created: getCurrentHour(),
      choices: [
        ChoiceModel(
          message: MessageModel(
            content: message,
            role: "user",
          ),
        )
      ],
    ));
     _chatViewModel.chatWithSupport(message, "apikey");
    _textEditingController.clear();
    Future.delayed(Durations.long2, _scrollToEnd);
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String getCurrentHour() {
    final now = DateTime.now();
    final int currentHour = now.hour;
    final int currentMinute = now.minute;
    int hour12 = currentHour > 12 ? currentHour - 12 : currentHour;
    String period = currentHour >= 12 ? 'PM' : 'AM';
    return "$hour12:$currentMinute $period";
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dot(animation: _animation, delay: 0),
              const SizedBox(width: 4),
              Dot(animation: _animation, delay: 0.2),
              const SizedBox(width: 4),
              Dot(animation: _animation, delay: 0.4),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Animation<double> animation;
  final double delay;

  const Dot({super.key, required this.animation, required this.delay});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(delay, 1.0),
        ),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: message.isSentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color:
                      message.isSentByMe ? Colors.grey[200] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message.choices.isEmpty
                      ? "Something went wrong"
                      : message.choices.first.message.content,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                )),
            const SizedBox(height: 4),
            Text(
              message.created ?? "",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, this.onSend, required this.controller});
  final VoidCallback? onSend;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      width: width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          )),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              onSend!();
            },
          ),
        ],
      ),
    );
  }
}
