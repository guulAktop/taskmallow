import 'dart:convert';

class UserModel {
  String email;
  String? password;
  String? firstName;
  String? lastName;
  String? description;
  String? profilePhotoURL;
  DateTime? dateOfBirth;
  int? gender;
  String? linkedinProfileURL;
  String? twitterProfileURL;
  String? joinDate;
  List<String>? preferredCategories;
  String? notificationToken;

  UserModel({
    required this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.description,
    this.profilePhotoURL,
    this.dateOfBirth,
    this.gender,
    this.linkedinProfileURL,
    this.twitterProfileURL,
    this.joinDate,
    this.preferredCategories,
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
      'preferredCategories': preferredCategories?.toList() ?? [],
      'notificationToken': notificationToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] != null ? map['password'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      profilePhotoURL: map['profilePhotoURL'] != null ? map['profilePhotoURL'] as String : null,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int) : null,
      gender: map['gender'] != null ? map['gender'] as int : null,
      linkedinProfileURL: map['linkedinProfileURL'] != null ? map['linkedinProfileURL'] as String : null,
      twitterProfileURL: map['twitterProfileURL'] != null ? map['twitterProfileURL'] as String : null,
      joinDate: map['joinDate'] != null ? map['joinDate'] as String : null,
      preferredCategories: map['preferredCategories'] != null ? List<String>.from((map['preferredCategories'] as List<dynamic>)) : [],
      notificationToken: map['notificationToken'] != null ? map['notificationToken'] as String : null,
    );
  }
}
