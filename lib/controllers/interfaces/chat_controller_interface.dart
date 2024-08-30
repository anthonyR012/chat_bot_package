
import 'package:flutter/material.dart';

abstract class ChatControllerInterface<ModelMessage> extends ChangeNotifier {

  List<ModelMessage> get messages;
  ScrollController get scrollController;
  bool get isLoading;
  TextEditingController get textEditingController;
  Future<void> sendMessage([String? messageDefault]);

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

}