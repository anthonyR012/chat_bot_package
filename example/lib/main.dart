import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/data/api_datasource.dart';
import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/view/chat_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyOwnImplementationExample());
}

class UsingMyChatBotExample extends StatelessWidget {
  UsingMyChatBotExample({super.key});
  final ChatController chatController = ChatController(
      apiKey:
          "YOUR_API_KEY_HERE"); //replace YOUR_API_KEY_HERE with your own API key
  

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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
  Future<MessageChat> sendMessage({required String message}) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    //Make your own implementation here
    return MessageChat(
      content: message,
      created: '3:30 PM',
      role: "user",
    );
  }
}
