import 'dart:async';
import 'package:chat_bot/controllers/interfaces/chat_controller_interface.dart';
import 'package:chat_bot/data/api_datasource.dart';
import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/util/format_data_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatController extends ChatControllerInterface<ChatMessageModel> {
  final List<ChatMessageModel> _messages = [];
  final FormatDataUtil _formatDataUtil;
  final ApiDatasource _apiDatasource;

  @override
  final TextEditingController textEditingController;

  @override
  final ScrollController scrollController;

  @override
  bool isLoading = false;

  ChatController({
    http.Client? httpClient,
    TextEditingController? textEditingController,
    FormatDataUtil? formatDataUtil,
    ScrollController? scrollController,
    ParamsChatBot params = const ParamsChatBot(),
    required String apiKey,
    ApiDatasource? apiDatasource,
  })  : textEditingController =
            textEditingController ?? TextEditingController(),
        _formatDataUtil = formatDataUtil ?? FormatDataUtil(),
        scrollController = scrollController ?? ScrollController(),
        _apiDatasource = apiDatasource ??
            ApiDatasourceImpl(
                apiKey: apiKey,
                baseUrl: params.baseUrl,
                formatDataUtil: FormatDataUtil(),
                maxToken: params.maxToken,
                modelGpt: params.modelGpt,
                httpClient: httpClient);

  @override
  List<ChatMessageModel> get messages => _messages;

  @override
  Future<void> sendMessage([String? messageDefault]) async {
    try {
      String message = messageDefault ?? textEditingController.text;
      if (message.isEmpty) return;
      messages.add(ChatMessageModel(
        isSentByMe: true,
        created: _formatDataUtil.getCurrentHour(),
        choices: [
          ChoiceModel(
            message: MessageModel(
              content: message,
              role: "user",
            ),
          )
        ],
      ));
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

  void _handleUnexpectedError(String errorMessage) {
    ChatMessageModel chatMessage = ChatMessageModel(choices: [
      ChoiceModel(message: MessageModel(content: errorMessage, role: "Error"))
    ]);
    _messages.add(chatMessage);
  }
}

class ParamsChatBot {
  final String baseUrl;
  final String modelGpt;
  final int maxToken;

  const ParamsChatBot(
      {this.baseUrl = "api.openai.com/v1/chat/completions",
      this.modelGpt = "gpt-3.5-turbo",
      this.maxToken = 150});
}
