import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField(
      {super.key,
      required this.onSend,
      required this.controller,
      ChatInputStyle? style})
      : style = style ?? const ChatInputStyle();
  final VoidCallback onSend;
  final TextEditingController controller;
  final ChatInputStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            style: style.styleText,
            decoration: style.inputDecoration,
          )),
          IconButton(
            icon: style.icon,
            style: style.styleIconButton,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class ChatInputStyle {
  final TextStyle styleText;
  final ButtonStyle? styleIconButton;
  final InputDecoration? inputDecoration;
  final Icon icon;

  const ChatInputStyle(
      {this.styleText = const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.icon = const Icon(Icons.send, color: Colors.black),
      this.inputDecoration,
      this.styleIconButton});
}
