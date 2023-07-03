import 'dart:convert';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/user_model.dart';

class InvitationModel {
  String id;
  UserModel fromUser;
  UserModel toUser;
  ProjectModel project;
  int? createdDate;

  InvitationModel({
    this.id = "",
    required this.fromUser,
    required this.toUser,
    required this.project,
    this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fromUser': (fromUser..password = null).toMap(),
      'toUser': (toUser..password = null).toMap(),
      'project': (project..userWhoCreated.password = null).toMap(),
      'createdDate': createdDate ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory InvitationModel.fromMap(Map<dynamic, dynamic> map) {
    return InvitationModel(
      id: map['id'] as String,
      fromUser: UserModel.fromMap(map['fromUser'] as Map<dynamic, dynamic>),
      toUser: UserModel.fromMap(map['toUser'] as Map<dynamic, dynamic>),
      project: ProjectModel.fromMap(map['project'] as Map<dynamic, dynamic>),
      createdDate: map['createdDate'] != null ? map['createdDate'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvitationModel.fromJson(String source) => InvitationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
