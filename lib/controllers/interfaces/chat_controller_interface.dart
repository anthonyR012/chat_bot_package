import 'package:flutter/material.dart';

/// The interface allows you to handle a new implementation.
abstract class ChatControllerInterface<ModelMessage> extends ChangeNotifier {
  /// The chat messages
  List<ModelMessage> get messages;
  set messages(List<ModelMessage> messages);
  ScrollController get scrollController;
  /// Whether the user is sending a message and waiting for a response
  bool get isLoading;
  TextEditingController get textEditingController;
  FocusNode get focusNode;
  Future<void> sendMessage([String? messageDefault]);

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
