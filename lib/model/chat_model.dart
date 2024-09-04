import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel {
  final String? id;

  final String? model;
  final List<ChoiceModel> choices;

  const ChatMessageModel({
    required this.choices,
    this.id,
    this.model,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json["id"],
        model: json["model"],
        choices: List<ChoiceModel>.from(
            json["choices"].map((x) => ChoiceModel.fromJson(x))),
      );

  factory ChatMessageModel.empty() =>
      const ChatMessageModel(id: "", model: "", choices: []);

  Map<String, dynamic> toJson() => {
        "id": id,
        "model": model,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };

  ChatMessageModel copyWith({
    String? id,
    String? object,
    String? created,
    String? model,
    List<ChoiceModel>? choices,
    bool? isSentByMe,
  }) =>
      ChatMessageModel(
        id: id ?? this.id,
        model: model ?? this.model,
        choices: choices ?? this.choices,
      );
}

class ChoiceModel {
  final int? index;
  final MessageChat message;

  ChoiceModel({
    this.index,
    required this.message,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) => ChoiceModel(
        index: json["index"],
        message: MessageChat.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "message": message.toJson(),
      };
}

class MessageChat {
  final String role;
  final String content;
  final bool isSentByMe;
  final String created;

  MessageChat({
    required this.role,
    required this.content,
    required this.created,
    this.isSentByMe = false,
  });

  factory MessageChat.fromJson(Map<String, dynamic> json) => MessageChat(
        role: json["role"],
        created: json["created"] ?? "",
        content: json["content"],
        isSentByMe: json["is_sent_by_me"] ?? false,
      );

  MessageChat copyWith(
          {String? role, String? content, String? created, bool? isSentByMe}) =>
      MessageChat(
        role: role ?? this.role,
        content: content ?? this.content,
        created: created ?? this.created,
        isSentByMe: isSentByMe ?? this.isSentByMe,
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
        "is_sent_by_me": isSentByMe,
        "created": created
      };
}
