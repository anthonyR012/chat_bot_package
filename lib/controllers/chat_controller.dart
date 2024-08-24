import 'dart:convert';
import 'dart:io';
import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/util/format_data_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  bool isLoading = false;
  final List<ChatMessageModel> _messages = [];
  final ParamsChatBot _params;
  final String? _apiKey;
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  final Dio _dio = Dio();
  final FormatDataUtil _formatDataUtil;

  ChatController({
    TextEditingController? textEditingController,
    FormatDataUtil? formatDataUtil,
    ScrollController? scrollController,
    ParamsChatBot params = const ParamsChatBot(),
    String? apiKey,
  })  : textEditingController =
            textEditingController ?? TextEditingController(),
        _formatDataUtil = formatDataUtil ?? FormatDataUtil(),
        scrollController = scrollController ?? ScrollController(),
        _params = params,
        _apiKey = apiKey;

  List<ChatMessageModel> get messages => _messages;

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
      final Options options = _params.options ??
          Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
            HttpHeaders.contentTypeHeader: 'application/json',
          });

      final Response response = await _dio
          .post(_params.baseUrl,
              options: options,
              data: _params.data ?? _getDataBot(message),
              queryParameters: _params.queryParameters)
          .timeout(const Duration(seconds: 30));

      _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleUnknownError(e);
    }
    isLoading = false;
    notifyListeners();
    Future.delayed(Durations.medium4, scrollToEnd);
  }

  void _handleResponse(Response response) {
    if (response.statusCode == 200) {
      ChatMessageModel chatMessage =
          chatMessageModelFromJson(jsonEncode(response.data));
      chatMessage =
          chatMessage.copyWith(created: _formatDataUtil.getCurrentHour());
      _messages.add(chatMessage);
    } else {
      ChatMessageModel chatMessage = ChatMessageModel(choices: [
        ChoiceModel(
            message: MessageModel(
                content:
                    'Error: ${response.statusCode} - ${response.statusMessage}',
                role: "Error"))
      ]);
      _messages.add(chatMessage);
    }
  }

  void _handleDioError(DioException e) {
    String errorMessage;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Connection timed out';
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = 'Received invalid status code: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.cancel) {
      errorMessage = 'Request was cancelled';
    } else {
      errorMessage = 'Unexpected error occurred: ${e.message}';
    }

    ChatMessageModel chatMessage = ChatMessageModel(choices: [
      ChoiceModel(message: MessageModel(content: errorMessage, role: "Error"))
    ]);
    _messages.add(chatMessage);
  }

  void _handleUnknownError(Object e) {
    ChatMessageModel chatMessage = ChatMessageModel(choices: [
      ChoiceModel(
          message: MessageModel(
              content: 'An unknown error occurred: $e', role: "Error"))
    ]);
    _messages.add(chatMessage);
  }

  String _getDataBot(String message) {
    return jsonEncode({
      'model': _params.modelGpt,
      'messages': [
        {'role': 'user', 'content': message},
      ],
      'max_tokens': _params.maxToken,
    });
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ParamsChatBot {
  final String baseUrl;
  final String modelGpt;
  final int maxToken;
  final String? data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;

  const ParamsChatBot(
      {this.data,
      this.options,
      this.queryParameters,
      this.baseUrl = "https://api.openai.com/v1/chat/completions",
      this.modelGpt = "gpt-3.5-turbo",
      this.maxToken = 150});
}
