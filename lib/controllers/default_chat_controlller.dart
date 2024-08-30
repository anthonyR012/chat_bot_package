
import 'package:flutter/material.dart';

import 'interfaces/chat_controller_interface.dart';

class ChatCustomController<T> extends ChatControllerInterface<T> {
  @override
  bool get isLoading => throw UnimplementedError();

  @override
  List<T> get messages => throw UnimplementedError();

  @override
  ScrollController get scrollController => throw UnimplementedError();

  @override
  Future<void> sendMessage([String? messageDefault]) {
    throw UnimplementedError();
  }

  @override
  TextEditingController get textEditingController => throw UnimplementedError();
  
}