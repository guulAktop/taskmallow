import 'dart:convert';
import 'package:taskmallow/constants/image_constants.dart';

class UserModel {
  String email;
  String? password;
  String firstName;
  String lastName;
  String description;
  String profilePhotoURL;
  DateTime? dateOfBirth;
  int? gender;
  String linkedinProfileURL;
  String twitterProfileURL;
  String? joinDate;
  List<String> preferredCategories;
  List<String> favoriteProjects;
  String? notificationToken;

  UserModel({
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.description,
    this.profilePhotoURL = ImageAssetKeys.defaultProfilePhotoUrl,
    this.dateOfBirth,
    this.gender,
    required this.linkedinProfileURL,
    required this.twitterProfileURL,
    this.joinDate,
    this.preferredCategories = const [],
    this.favoriteProjects = const [],
    this.notificationToken,
  });

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'description': description,
      'profilePhotoURL': profilePhotoURL,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'gender': gender,
      'linkedinProfileURL': linkedinProfileURL,
      'twitterProfileURL': twitterProfileURL,
      'joinDate': joinDate ?? DateTime.now().toString(),
      'preferredCategories': preferredCategories.toList(),
      'favoriteProjects': favoriteProjects.toList(),
      'notificationToken': notificationToken,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] != null ? map['password'] as String : null,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      description: map['description'] as String,
      profilePhotoURL: map['profilePhotoURL'] as String,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int) : null,
      gender: map['gender'] != null ? map['gender'] as int : null,
      linkedinProfileURL: map['linkedinProfileURL'] as String,
      twitterProfileURL: map['twitterProfileURL'] as String,
      joinDate: map['joinDate'] != null ? map['joinDate'] as String : null,
      preferredCategories: map['preferredCategories'] != null ? List<String>.from((map['preferredCategories'] as List<dynamic>)) : [],
      favoriteProjects: map['favoriteProjects'] != null ? List<String>.from((map['favoriteProjects'] as List<dynamic>)) : [],
      notificationToken: map['notificationToken'] != null ? map['notificationToken'] as String : null,
    );
  }
}
