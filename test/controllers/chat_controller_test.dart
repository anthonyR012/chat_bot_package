
import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/model/chat_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import '../mocks_test.dart';
import '../mocks_test.mocks.dart';

void main() {
  late ChatController chatController;
  late MockScrollController mockScrollController;
  late MockTextEditingController mockTextEditingController;
  late MockFormatDataUtil mockFormatDataUtil;
  late MockScrollPosition mockScrollPosition;
  late MockApiDatasource mockApiDatasource;

  setUp(() {
    mockApiDatasource = MockApiDatasource();
    mockScrollController = MockScrollController();
    mockScrollPosition = MockScrollPosition();
    mockTextEditingController = MockTextEditingController();
    mockFormatDataUtil = MockFormatDataUtil();
    chatController = ChatController(
      scrollController: mockScrollController,
      textEditingController: mockTextEditingController,
      datasource: mockApiDatasource,
      params: ParamsChatBot(
        baseUrl: "example.com",
        formatDataUtil: mockFormatDataUtil,
      ),
    );
  });

  test('sendMessage adds a new message and clears the text field', () async {
    when(mockScrollController.position).thenReturn(mockScrollPosition);
    when(mockTextEditingController.text).thenReturn('Hello');
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockApiDatasource.sendMessage(message: anyNamed('message')))
        .thenAnswer((_) async => ChatMessageModel(choices: [
              ChoiceModel(
                  message: MessageModel(
                      content: "Hi", role: "Error"))
            ]));
    await chatController.sendMessage();
    expect(chatController.messages.length, 2);
    expect(chatController.messages.last.choices.first.message.content, 'Hi');
    verify(mockTextEditingController.clear()).called(1);
  });

  test('sendMessage handles errors correctly', () async {
    when(mockScrollController.position).thenReturn(mockScrollPosition);
    when(mockTextEditingController.text).thenReturn('Hello');
    when(mockFormatDataUtil.getCurrentHour()).thenReturn('3:30 PM');
    when(mockApiDatasource.sendMessage(message: anyNamed('message')))
        .thenAnswer((_) async => ChatMessageModel(choices: [
              ChoiceModel(
                  message: MessageModel(
                      content: "No Internet connection", role: "Error"))
            ]));

    await chatController.sendMessage();

    expect(chatController.messages.length, 2);
    expect(chatController.messages.last.choices.first.message.content,
        'No Internet connection');
  });

  test('sendMessage does nothing if message is empty', () async {
    when(mockTextEditingController.text).thenReturn('');

    await chatController.sendMessage();

    expect(chatController.messages.isEmpty, true);
    verifyNever(mockApiDatasource.sendMessage(message:anyNamed('message')));
  });
}
