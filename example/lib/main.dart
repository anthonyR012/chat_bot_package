import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/view/chat_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(UsingMyChatBotExample());
}

class UsingMyChatBotExample extends StatelessWidget {
  UsingMyChatBotExample({super.key});
  final ChatController chatController = ChatController(apiKey: "");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Support chat"),
        ),
        body: ChatBot(
          chatController: chatController,
        ),
      ),
    );
  }
}

