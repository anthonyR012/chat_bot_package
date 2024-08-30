

import 'dart:convert';
import 'dart:io';

import 'package:chat_bot/data/api_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks_test.mocks.dart';

void main() {
  late ApiDatasourceImpl apiDatasource;
  late MockClient mockHttp;
  late MockResponse mockResponse;
  late MockTextEditingController mockTextEditingController;
  late MockFormatDataUtil mockFormatDataUtil;


  setUp(() {
    mockHttp = MockClient();
    mockResponse = MockResponse();
    mockTextEditingController = MockTextEditingController();
    mockFormatDataUtil = MockFormatDataUtil();
    apiDatasource = ApiDatasourceImpl(
        apiKey: "API_KEY",
        baseUrl: "example.com",
        maxToken: 150,
        modelGpt: "gpt-3.5-turbo",
        formatDataUtil: mockFormatDataUtil,
        httpClient: mockHttp);
  });

  test('sendMessage and get correct response', () async {
    when(mockResponse.statusCode).thenReturn(200);
    when(mockResponse.body).thenReturn(json.encode({
      'choices': [
        {
          'message': {'content': 'Hi', 'role': 'bot'}
        }
      ]
    }));
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockHttp.post(any,
            body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    final chatmessage = await apiDatasource.sendMessage(message: "Hi bot");

    expect(chatmessage.choices.first.message.content, "Hi");
    expect(chatmessage.choices.first.message.role, 'bot');
  });

  test('sendMessage and get error', () async {
    when(mockTextEditingController.text).thenReturn('Hello');
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockHttp.post(any,
            body: anyNamed('body'), headers: anyNamed('headers')))
        .thenThrow(const SocketException('Connection timed out'));

    final message = await apiDatasource.sendMessage(message: "Hi bot");

    expect(message.choices.first.message.content, 'No Internet connection');
  });
}
