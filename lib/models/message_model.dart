import 'dart:convert';
import 'package:taskmallow/models/user_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class MessageModel {
  String? id;
  String content;
  UserModel userWhoSended;
  int messageDate;
  bool hasImage;
  String? imageUrl;

  MessageModel({
    id,
    required this.content,
    required this.userWhoSended,
    required this.messageDate,
    this.hasImage = false,
    this.imageUrl,
  }) : id = uuid.v1();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'userWhoSended': userWhoSended.toMap(),
      'messageDate': messageDate,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
    };
  }

  factory MessageModel.fromMap(Map<dynamic, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      userWhoSended: UserModel.fromMap(map['userWhoSended'] as Map<dynamic, dynamic>),
      messageDate: map['messageDate'] as int,
      hasImage: map['hasImage'] as bool,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<dynamic, dynamic>);
}
