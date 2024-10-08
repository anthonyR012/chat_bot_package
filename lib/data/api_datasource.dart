import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/model/chat_model.dart';
import 'package:http/http.dart' as http;

/// Base class for chat bot
abstract class ChatBotDatasource {
  /// Send a message to the chat bot
  Future<MessageChat> sendMessage({required String message});
}

/// Default implementation for chat bot
/// [ChatBotDatasource] can be overridden by your own implementation
/// Use: [class MyOverrideDatasource extends ChatBotDatasource] or [class MyOverrideDatasource implements ChatBotDatasource]
class ApiDatasourceImpl implements ChatBotDatasource {
  final http.Client _http;
  final String _apiKey;
  final ParamsChatBot _params;

  ApiDatasourceImpl({
    http.Client? httpClient,
    required ParamsChatBot params,
    required String apiKey,
  })  : _http = httpClient ?? http.Client(),
        _apiKey = apiKey,
        _params = params;

  @override
  Future<MessageChat> sendMessage({required String message}) async {
    late MessageChat chatMessage;
    try {
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      var url = Uri.https(_params.domain, _params.endPoint);
      var body = json.encode({
        'model': _params.modelGpt,
        'messages': [
          {'role': 'user', 'content': message},
        ],
        'max_tokens': _params.maxToken,
      });
      var response = await _http
          .post(url, body: body, headers: headers)
          .timeout(const Duration(seconds: 30));

      chatMessage = _handleResponse(response);
    } on SocketException {
      chatMessage = _handleHttpError('No Internet connection');
    } on TimeoutException {
      chatMessage = _handleHttpError('Connection timed out');
    } on http.ClientException catch (e) {
      chatMessage = _handleHttpError('Client exception occurred: ${e.message}');
    } catch (e) {
      chatMessage = _handleHttpError('Unexpected error occurred: $e');
    }
    return chatMessage;
  }

  MessageChat _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      ChatMessageModel chatMessage = chatMessageModelFromJson(response.body);
      chatMessage = chatMessage.copyWith(
          created: _params.formatDataUtil.getCurrentHour());
      MessageChat message = chatMessage.choices.first.message;
      message =
          message.copyWith(created: _params.formatDataUtil.getCurrentHour());
      return message;
    } else {
      return _handleHttpError(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  MessageChat _handleHttpError(String errorMessage) {
    MessageChat chatMessage = MessageChat(
        role: "Error",
        content: errorMessage,
        created: _params.formatDataUtil.getCurrentHour());
    return chatMessage;
  }
}
