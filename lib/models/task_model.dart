// ignore_for_file: unused_element, constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:taskmallow/utils/enum_utils.dart';

class TaskModel {
  final String id;
  final String projectId;
  final String name;
  final String description;
  late final TaskSituation situation;
  late final String assignedUserMail;
  final DateTime? createdDate;
  final bool isDeleted;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    this.situation = TaskSituation.to_do,
    required this.assignedUserMail,
    this.createdDate,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'situation': describeEnum(situation),
      'assignedUserMail': assignedUserMail,
      'createdDate': createdDate ?? DateTime.now().toString(),
      'isDeleted': isDeleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      situation: (map['situation'] as String).getEnumValue(TaskSituation.values) ?? TaskSituation.to_do,
      assignedUserMail: map['assignedUserMail'] as String,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      isDeleted: map['isDeleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static TaskSituation _getTaskSituationFromValue(String value) {
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
