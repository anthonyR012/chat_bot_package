import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/model/chat_model.dart';
import 'package:chat_bot/util/format_data_util.dart';
import 'package:http/http.dart' as http;

abstract class ApiDatasource {
  Future<ChatMessageModel> sendMessage({required String message});
}

class ApiDatasourceImpl implements ApiDatasource {
  final http.Client _http;
  final String _apiKey;
  final String baseUrl;
  final String modelGpt;
  final FormatDataUtil formatDataUtil;
  final int maxToken;

  ApiDatasourceImpl({
    http.Client? httpClient,
    required String apiKey,
    required this.baseUrl,
    required this.modelGpt,
    required this.formatDataUtil,
    required this.maxToken,
  })  : _http = httpClient ?? http.Client(),
        _apiKey = apiKey;

  @override
  Future<ChatMessageModel> sendMessage({required String message}) async {
    late ChatMessageModel chatMessage;
    try {
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      var url = Uri.https(baseUrl);
      var body = json.encode({
        'model': modelGpt,
        'messages': [
          {'role': 'user', 'content': message},
        ],
        'max_tokens': maxToken,
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

  ChatMessageModel _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      ChatMessageModel chatMessage = chatMessageModelFromJson(response.body);
      chatMessage =
          chatMessage.copyWith(created: formatDataUtil.getCurrentHour());
      return chatMessage;
    } else {
      return _handleHttpError(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  ChatMessageModel _handleHttpError(String errorMessage) {
    ChatMessageModel chatMessage = ChatMessageModel(choices: [
      ChoiceModel(message: MessageModel(content: errorMessage, role: "Error"))
    ]);
    return chatMessage;
  }
}
