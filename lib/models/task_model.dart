// ignore_for_file: unused_element, constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:taskmallow/utils/enum_utils.dart';

class TaskModel {
  String id;
  String viewId;
  String name;
  String description;
  TaskSituation situation;
  String? assignedUserMail;
  int? createdDate;
  bool isDeleted;

  TaskModel({
    this.id = "",
    required this.viewId,
    required this.name,
    required this.description,
    this.situation = TaskSituation.to_do,
    this.assignedUserMail,
    this.createdDate,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'viewId': viewId,
      'description': description,
      'situation': describeEnum(situation),
      'assignedUserMail': assignedUserMail,
      'createdDate': createdDate ?? DateTime.now().millisecondsSinceEpoch,
      'isDeleted': isDeleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      name: map['name'] as String,
      viewId: map['viewId'] as String,
      description: map['description'] as String,
      situation: (map['situation'] as String).getEnumValue(TaskSituation.values) ?? TaskSituation.to_do,
      assignedUserMail: map['assignedUserMail'] != null ? map['assignedUserMail'] as String : null,
      createdDate: map['createdDate'] != null ? map['createdDate'] as int : null,
      isDeleted: map['isDeleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static TaskSituation getTaskSituationFromValue(String value) {
    switch (value) {
      case 'to_do':
        return TaskSituation.to_do;
      case 'in_progress':
        return TaskSituation.in_progress;
      case 'done':
        return TaskSituation.done;
      default:
        return TaskSituation.to_do;
    }
  }
}

class TaskSituationsConstants {
  List<String> situations = ["to_do", "in_progress", "done"];
}

enum TaskSituation { to_do, in_progress, done }
