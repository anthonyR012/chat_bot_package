import 'package:chat_bot/controllers/chat_controller.dart';
import 'package:chat_bot/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should find a TextField and an IconButton to add a message',
      (WidgetTester tester) async {
    //find widgets
    final addField = find.byType(TextField);
    final addButton = find.byType(IconButton);
    //execute
    await tester.pumpWidget(MaterialApp(
        home: ChatBot(chatController: ChatController(apiKey: "API_KEY"))));

    //verify
    expect(addField, findsOneWidget);
    expect(addButton, findsOneWidget);
  });

  testWidgets('should add a new message and clear the text field',
      (WidgetTester tester) async {
    //find widgets
    final addField = find.byType(TextField);
    final addButton = find.byType(IconButton);
    //execute
    await tester.pumpWidget(MaterialApp(
        home: ChatBot(chatController: ChatController(apiKey: "API_KEY"))));
    await tester.enterText(addField, 'test');
    await tester.tap(addButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    //verify
    expect(find.text('test'), findsOneWidget);
  });
}
