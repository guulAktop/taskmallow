import 'dart:convert';

class UserModel {
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final String description;
  final String profilePhotoURL;
  final DateTime dateOfBirth;
  final int gender;
  final String? linkedinProfileURL;
  final String? twitterProfileURL;
  final DateTime joinDate;
  final List<String>? preferredCategories;
  final String? notificationToken;

  UserModel({
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.profilePhotoURL,
    required this.dateOfBirth,
    required this.gender,
    this.linkedinProfileURL,
    this.twitterProfileURL,
    required this.joinDate,
    this.preferredCategories,
    this.notificationToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'description': description,
      'profilePhotoURL': profilePhotoURL,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'gender': gender,
      'linkedinProfileURL': linkedinProfileURL,
      'twitterProfileURL': twitterProfileURL,
      'joinDate': joinDate.millisecondsSinceEpoch,
      'preferredCategories': preferredCategories,
      'notificationToken': notificationToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] != null ? map['password'] as String : null,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      description: map['description'] as String,
      profilePhotoURL: map['profilePhotoURL'] as String,
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      gender: map['gender'] as int,
      linkedinProfileURL: map['linkedinProfileURL'] != null ? map['linkedinProfileURL'] as String : null,
      twitterProfileURL: map['twitterProfileURL'] != null ? map['twitterProfileURL'] as String : null,
      joinDate: DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int),
      preferredCategories: map['preferredCategories'] != null ? List<String>.from((map['preferredCategories'] as List<String>)) : null,
      notificationToken: map['notificationToken'] != null ? map['notificationToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
