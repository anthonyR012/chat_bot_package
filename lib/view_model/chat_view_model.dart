import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/model/chat_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.openai.com/v1/chat/completions";
  bool isLoading = false;
  List<ChatMessageModel> _messages = [];
  List<ChatMessageModel> get messages => _messages;

  Future<void> chatWithSupport(String message, String apikey) async {
    isLoading = true;
    notifyListeners();

    try {
      final Options options = Options(headers: {
        HttpHeaders.authorizationHeader: 'Bearer $apikey',
        HttpHeaders.contentTypeHeader: 'application/json'
      });

      final Response response = await _dio
          .post(
            _baseUrl,
            options: options,
            data: jsonEncode({
              'model': 'gpt-3.5-turbo',
              'messages': [
                {'role': 'user', 'content': message},
              ],
              'max_tokens': 150,
            }),
          )
          .timeout(const Duration(seconds: 30)); // Adjust timeout as needed

      if (response.statusCode == 200) {
        ChatMessageModel chatMessage =
            chatMessageModelFromJson(jsonEncode(response.data));
        _messages.add(chatMessage);
      } else {
        // Handle error response
      }
    } catch (e) {
      // Handle network or other errors
    }

    isLoading = false;
    notifyListeners();
  }
}