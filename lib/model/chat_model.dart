import 'dart:convert';

import 'package:equatable/equatable.dart';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel extends Equatable {
  final String? id;
  final String? created;
  final String? model;
  final bool isSentByMe;
  final List<ChoiceModel> choices;

  const ChatMessageModel({
    required this.choices,
    this.id,
    this.model,
    this.created,
    this.isSentByMe = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json["id"],
        created: json["created_at"] ?? DateTime.now().hour.toString(),
        model: json["model"],
        choices: List<ChoiceModel>.from(
            json["choices"].map((x) => ChoiceModel.fromJson(x))),
      );

  factory ChatMessageModel.empty() => const ChatMessageModel(
      id: "",
      created: "",
      model: "",
      choices: [],
      isSentByMe: false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created,
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
        created: created ?? this.created,
        model: model ?? this.model,
        choices: choices ?? this.choices,
        isSentByMe: isSentByMe ?? this.isSentByMe,
      );

  @override
  List<Object?> get props => [
        id,
        created,
        model,
        choices,
        isSentByMe,
      ];
}

class ChoiceModel {
  final int? index;
  final MessageModel message;

  ChoiceModel({
    this.index,
    required this.message,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) => ChoiceModel(
        index: json["index"],
        message: MessageModel.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "message": message.toJson(),
      };
}

class MessageModel {
  final String role;
  final String content;

  MessageModel({
    required this.role,
    required this.content
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}
