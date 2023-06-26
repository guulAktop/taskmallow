import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/models/project_model.dart';

class TaskRepository extends ChangeNotifier {
  CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  ProjectModel? projectModel;
  List<ProjectModel> allProjects = [];
  List<ProjectModel> allProjectsInvolved = [];
  bool isSucceeded = false;
  bool isLoading = true;
}
