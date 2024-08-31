import 'package:chat_bot/model/chat_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final MessageChat message;
  final StyleReceivedByMe styleReceivedByMe;
  final StyleSentByMe styleSentByMe;
  final TextStyle? styleTextHour;

  const ChatBubble(
      {super.key,
      required this.message,
      this.styleTextHour,
      StyleSentByMe? styleSentByMe,
      StyleReceivedByMe? styleReceivedByMe})
      : styleSentByMe = styleSentByMe ?? const StyleSentByMe(),
        styleReceivedByMe = styleReceivedByMe ?? const StyleReceivedByMe();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decorationDefault = BoxDecoration(
      color: message.isSentByMe ? Colors.grey[200] : Colors.grey[400],
      borderRadius: BorderRadius.circular(16),
    );
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
                decoration: message.isSentByMe
                    ? styleSentByMe.decoration ?? decorationDefault
                    : styleReceivedByMe.decoration ?? decorationDefault,
                child: Text(
                  message.content,
                  style: message.isSentByMe
                      ? styleSentByMe.styleMessage
                      : styleReceivedByMe.styleMessage,
                )),
            const SizedBox(height: 4),
            Text(
              message.created,
              style: styleTextHour ??
                  TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class StyleSentByMe {
  final TextStyle styleMessage;
  final BoxDecoration? decoration;

  const StyleSentByMe(
      {this.styleMessage = const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.decoration});
}

class StyleReceivedByMe {
  final TextStyle styleMessage;
  final BoxDecoration? decoration;

  const StyleReceivedByMe(
      {this.styleMessage = const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.decoration});
}
