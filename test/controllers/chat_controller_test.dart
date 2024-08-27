import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks_test.dart';
import '../mocks_test.mocks.dart';

void main() {
  late ChatController chatController;
  late MockDio mockDio;
  late MockScrollController mockScrollController;
  late MockTextEditingController mockTextEditingController;
  late MockFormatDataUtil mockFormatDataUtil;

  setUp(() {
    mockDio = MockDio();
    mockScrollController = MockScrollController();
    mockTextEditingController = MockTextEditingController();
    mockFormatDataUtil = MockFormatDataUtil();
    chatController = ChatController(
        scrollController: mockScrollController,
        textEditingController: mockTextEditingController,
        formatDataUtil: mockFormatDataUtil,
        dio: mockDio);
  });

  test('sendMessage adds a new message and clears the text field', () async {
    when(mockScrollController.position).thenReturn(MockScrollPosition());
    when(mockTextEditingController.text).thenReturn('Hello');
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockDio.post(any,
            options: anyNamed('options'), data: anyNamed('data')))
        .thenAnswer((_) async => Response(data: {
              'choices': [
                {
                  'message': {'content': 'Hi', 'role': 'bot'}
                }
              ]
            }, statusCode: 200, requestOptions: RequestOptions(path: '')));

    await chatController.sendMessage();

    expect(chatController.messages.length, 2);
    expect(chatController.messages.last.choices.first.message.content, 'Hi');
    verify(mockTextEditingController.clear()).called(1);
  });

  test('sendMessage handles Dio errors correctly', () async {
    when(mockScrollController.position).thenReturn(MockScrollPosition());
    when(mockTextEditingController.text).thenReturn('Hello');
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockDio.post(any,
            options: anyNamed('options'), data: anyNamed('data')))
        .thenThrow(DioException(
      type: DioExceptionType.connectionTimeout,
      requestOptions: RequestOptions(path: ''),
    ));

    await chatController.sendMessage();

    expect(chatController.messages.length, 2);
    expect(chatController.messages.last.choices.first.message.content,
        'Connection timed out');
  });

  test('sendMessage does nothing if message is empty', () async {
   when(mockTextEditingController.text).thenReturn('');

    await chatController.sendMessage();

    expect(chatController.messages.isEmpty, true);
    verifyNever(mockDio.post(any,
        options: anyNamed('options'), data: anyNamed('data')));
  });
}
