// ignore_for_file: unused_element, constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/utils/enum_utils.dart';

class ProjectModel {
  final String id;
  final String name;
  final Category category;
  final String description;
  final DateTime? createdDate;
  final UserModel userWhoCreated;
  final List<UserModel> collaborators;
  final List<TaskModel> tasks;

  ProjectModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.createdDate,
    required this.userWhoCreated,
    required this.collaborators,
    required this.tasks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': describeEnum(category),
      'description': description,
      'createdDate': createdDate ?? DateTime.now().toString(),
      'userWhoCreated': userWhoCreated.toMap(),
      'collaborators': collaborators.map((x) => x.toMap()).toList(),
      'tasks': tasks.map((x) => x.toMap()).toList(),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: (map['category'] as String).getEnumValue(Category.values) ?? Category.other_category,
      description: map['description'] as String,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      userWhoCreated: UserModel.fromMap(map['userWhoCreated'] as Map<String, dynamic>),
      collaborators: List<UserModel>.from(
        (map['collaborators'] as List<int>).map<UserModel>(
          (x) => UserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      tasks: List<TaskModel>.from(
        (map['tasks'] as List<int>).map<TaskModel>(
          (x) => TaskModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static Category _getCategoryFromValue(String value) {
    switch (value) {
      case 'artificial_intelligence':
        return Category.artificial_intelligence;
      case 'mobile_applications':
        return Category.mobile_applications;
      case 'data_analytics':
        return Category.data_analytics;
      case 'cloud_computing':
        return Category.cloud_computing;
      case 'internet_of_things_iot':
        return Category.internet_of_things_iot;
      case 'education_and_learning':
        return Category.education_and_learning;
      case 'sustainable_development':
        return Category.sustainable_development;
      case 'social_equality':
        return Category.social_equality;
      case 'human_centered_design':
        return Category.human_centered_design;
      case 'social_entrepreneurship':
        return Category.social_entrepreneurship;
      case 'renewable_energy_sources':
        return Category.renewable_energy_sources;
      case 'energy_efficiency':
        return Category.energy_efficiency;
      case 'waste_management':
        return Category.waste_management;
      case 'environmental_sustainability':
        return Category.environmental_sustainability;
      case 'climate_change_adaptation':
        return Category.climate_change_adaptation;
      case 'interior_design':
        return Category.interior_design;
      case 'urban_design':
        return Category.urban_design;
      case 'sustainable_architecture':
        return Category.sustainable_architecture;
      case 'product_design':
        return Category.product_design;
      case 'visual_communication_design':
        return Category.visual_communication_design;
      case 'diagnostic_tools_and_technologies':
        return Category.diagnostic_tools_and_technologies;
      case 'digital_health_solutions':
        return Category.digital_health_solutions;
      case 'genetic_research':
        return Category.genetic_research;
      case 'cognitive_health':
        return Category.cognitive_health;
      case 'medical_imaging_technologies':
        return Category.medical_imaging_technologies;
      default:
        return Category.other_category;
    }
  }
}

enum Category {
  artificial_intelligence,
  mobile_applications,
  data_analytics,
  cloud_computing,
  internet_of_things_iot,
  education_and_learning,
  sustainable_development,
  social_equality,
  human_centered_design,
  social_entrepreneurship,
  renewable_energy_sources,
  energy_efficiency,
  waste_management,
  environmental_sustainability,
  climate_change_adaptation,
  interior_design,
  urban_design,
  sustainable_architecture,
  product_design,
  visual_communication_design,
  diagnostic_tools_and_technologies,
  digital_health_solutions,
  genetic_research,
  cognitive_health,
  medical_imaging_technologies,
  other_category
}
