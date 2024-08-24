
import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, this.onSend, required this.controller});
  final VoidCallback? onSend;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      width: width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          )),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              onSend!();
            },
          ),
        ],
      ),
    );
  }
}