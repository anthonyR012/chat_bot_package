

import 'package:chat_bot/model/chat_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: message.isSentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color:
                      message.isSentByMe ? Colors.grey[200] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message.choices.isEmpty
                      ? "Something went wrong"
                      : message.choices.first.message.content,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                )),
            const SizedBox(height: 4),
            Text(
              message.created ?? "",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}