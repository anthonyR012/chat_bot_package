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
            decoration: style.inputDecoration ??
                InputDecoration(
                  label: Text(
                    style.hintText ?? "Type a message...",
                    style: style.hintTextStyle ??
                        const TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
            focusNode: style.focusNode,
            minLines: style.minLines,
            maxLines: style.maxLines,
            onSubmitted: (value) => onSend(),
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
  final FocusNode? focusNode;
  final Icon icon;
  final int minLines;
  final int maxLines;
  final String? hintText;
  final TextStyle? hintTextStyle;

  const ChatInputStyle(
      {this.styleText = const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.hintText,
      this.hintTextStyle,
      this.minLines = 1,
      this.maxLines = 5,
      this.icon = const Icon(Icons.send, color: Colors.black),
      this.focusNode,
      this.inputDecoration,
      this.styleIconButton});
}


