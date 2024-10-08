import 'dart:async';
import 'package:chat_bot/controllers/interfaces/chat_controller_interface.dart';
import 'package:chat_bot/data/api_datasource.dart';
import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/util/format_data_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// The ChatController class manages the chat messages, interactions with the API, and controls
/// UI elements like focus, text input, and scroll position. It ensures that messages are sent
/// correctly and handles errors.
class ChatController extends ChatControllerInterface<MessageChat> {
  final List<MessageChat> _messages = [];
  final ChatBotDatasource _apiDatasource;
  final ParamsChatBot _params;
  @override
  final FocusNode focusNode;

  @override
  final TextEditingController textEditingController;

  @override
  final ScrollController scrollController;

  @override
  bool isLoading = false;
  /// Interface default implementation for chat bot
  ChatController({
    http.Client? httpClient,
    TextEditingController? textEditingController,
    ScrollController? scrollController,
    FocusNode? focusNode,
    ParamsChatBot? params,
    String? apiKey,
    ChatBotDatasource? datasource,
  })  : assert(
            (datasource != null && apiKey == null) ||
                (datasource == null && apiKey != null),
            "Either datasource or apiKey must be provided"),
        _params = params ?? const ParamsChatBot(),
        focusNode = focusNode ?? FocusNode(),
        textEditingController =
            textEditingController ?? TextEditingController(),
        scrollController = scrollController ?? ScrollController(),
        _apiDatasource = datasource ??
            ApiDatasourceImpl(
                apiKey: apiKey!,
                params: params ?? const ParamsChatBot(),
                httpClient: httpClient);

  @override
  List<MessageChat> get messages => _messages;

  @override
  Future<void> sendMessage([String? messageDefault]) async {
    try {
      String message = messageDefault ?? textEditingController.text;
      assert(message.isNotEmpty, "Message cannot be empty");
      if (message.isEmpty) return;
      messages.add(MessageChat(
          content: message,
          isSentByMe: true,
          created: _params.formatDataUtil.getCurrentHour(),
          role: "user"));
      textEditingController.clear();
      isLoading = true;
      notifyListeners();
      scrollToEnd();
      final responseMessage =
          await _apiDatasource.sendMessage(message: message);
      messages.add(responseMessage);
    } catch (e) {
      _handleUnexpectedError('Unexpected error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      Future.delayed(Durations.medium4, scrollToEnd);
    }
  }

  /// Sends a message anonymously which does not appear in the chat history
  Future<void> sendAnonymously({required String message}) async {
    try {
      assert(message.isNotEmpty, "Message cannot be empty");
      if (message.isEmpty) return;
      textEditingController.clear();
      isLoading = true;
      notifyListeners();
      final responseMessage =
          await _apiDatasource.sendMessage(message: message);
      messages.add(responseMessage);
    } catch (e) {
      _handleUnexpectedError('Unexpected error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _handleUnexpectedError(String errorMessage) {
    MessageChat chatMessage = MessageChat(
        created: _params.formatDataUtil.getCurrentHour(),
        content: errorMessage,
        role: "Error");
    _messages.add(chatMessage);
  }
  
  @override
  set messages(List<MessageChat> messages) {
    messages  = messages;
    notifyListeners();
  }
}

/// Main configuration for chat bot
class ParamsChatBot {
  final String domain;
  final String endPoint;
  final String modelGpt;
  final int maxToken;
  final FormatDataUtil formatDataUtil;
  
  const ParamsChatBot({
    this.domain = "api.openai.com",
    this.endPoint = "/v1/chat/completions",
    this.modelGpt = "gpt-3.5-turbo",
    this.maxToken = 150,
    this.formatDataUtil = const FormatDataUtil(),
  });
}
