import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmallow/models/user_model.dart';

class UserRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference notificationTokens = FirebaseFirestore.instance.collection('notificationTokens');

  UserModel? userModel;
  bool isSucceeded = false;

  Future<void> update(UserModel user) async {
    try {
      await getUser(user.email);
      user.joinDate = userModel?.joinDate;
      user.notificationToken = userModel?.notificationToken;
    } catch (e) {
      debugPrint(e.toString());
    }
    await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await users.doc(user.email).update(user.toMap()).then((value1) {
          debugPrint("Profile updated.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while updating the profile!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Non existing user!");
        isSucceeded = false;
      }
    });
    notifyListeners();
  }

  Future<void> getUser(String email) async {
    DocumentSnapshot snapshot = await users.doc(email).get();
    userModel = UserModel.fromJson(json.encode(snapshot.data()));
    notifyListeners();
  }
}
