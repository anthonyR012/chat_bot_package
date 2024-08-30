import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/data/api_datasource.dart';
import 'package:chat_bot/model/chat_model.dart';
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

class MyOwnImplementationExample extends StatelessWidget {
  MyOwnImplementationExample({super.key});

  final ChatController chatController =
      ChatController(datasource: SendMessageImplementation());

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

class SendMessageImplementation extends ChatBotDatasource {
  @override
  Future<ChatMessageModel> sendMessage({required String message}) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    //Make your own implementation here
    return ChatMessageModel(choices: [
      ChoiceModel(
        message: MessageModel(
          content: message,
          role: "user",
        ),
      )
    ]);
  }
}
