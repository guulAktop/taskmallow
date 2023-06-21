import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/routes/route_constants.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference notificationTokens = FirebaseFirestore.instance.collection('notificationTokens');

  Future<bool> register(UserModel model) async {
    bool isSucceeded = false;
    await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('images').doc("profile").get().then((value) {
          model.profilePhotoURL = value.get("defaultProfilePhoto");
        });

        await users.doc(model.email).set(model.toMap()).then((value1) {
          debugPrint("User successfully added.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while adding the user!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Current user!");
        isSucceeded = false;
      }
    });
    return isSucceeded;
  }

  Future<UserModel?> login(UserModel model) async {
    UserModel? loggedUserModel;
    await users.where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isEmpty) {
        debugPrint("Non existing user!");
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: model.email)
            .where('password', isEqualTo: model.password)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            debugPrint("Wrong email or password!");
          } else {
            debugPrint(value.docs[0].data().toString());
            loggedUserModel = UserModel.fromMap(value.docs[0].data());
          }
        });
      }
    });
    return loggedUserModel;
  }

  void logout(BuildContext context) {
    SharedPreferencesHelper.remove("loggedUser");
    Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
  }

  Future<bool> updateUser(UserModel user) async {
    bool isSucceeded = false;
    try {
      UserModel userModel = await getUser(user.email);
      user.joinDate = userModel.joinDate;
      user.notificationToken = userModel.notificationToken;
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
    return isSucceeded;
  }

  Future<bool> deleteAccount(UserModel user) async {
    bool isSucceeded = false;
    final DocumentReference snapshot = users.doc(user.email);
    await snapshot.delete().then((value) {
      debugPrint("User successfully deleted.");
      isSucceeded = true;
    }).catchError((error) {
      debugPrint("An error occurred while deleting the User!");
      isSucceeded = false;
    });
    return isSucceeded;
  }

  Future<bool> updatePassword(UserModel model) async {
    bool isSucceeded = false;
    await users.where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await value.docs.first.reference.update({
          "password": model.password,
        }).then((value1) {
          debugPrint("Password updated.");
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
    return isSucceeded;
  }

  Future<bool> updateNotificationToken(UserModel user, String notificationToken) async {
    bool isSucceeded = false;
    await notificationTokens.doc(user.email).set({'notificationToken': notificationToken});
    await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await users.doc(user.email).update({
          "notificationToken": notificationToken,
        }).then((value1) {
          debugPrint("Notification Token updated.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while updating the Notification Token!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Non existing user!");
        isSucceeded = false;
      }
    });
    return isSucceeded;
  }

  Future<bool> setLoggedUser(UserModel user) async {
    return await SharedPreferencesHelper.setString("loggedUser", jsonEncode(user.toJson())).then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> hasProfile(String email) async {
    QuerySnapshot snapshot = await users.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      debugPrint("no user");
      return false;
    } else {
      debugPrint(snapshot.docs.first.data().toString());
      return true;
    }
  }

  Future<bool> userInfoFull(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
    var firstName = snapshot.docs[0].get("firstName");
    var lastName = snapshot.docs[0].get("lastName");
    var dateOfBirth = snapshot.docs[0].get("dateOfBirth");
    var gender = snapshot.docs[0].get("gender");

    if ((firstName == null || firstName.toString().isEmpty) ||
        (lastName == null || lastName.toString().isEmpty) ||
        (dateOfBirth == null || dateOfBirth.toString().isEmpty) ||
        (gender == null || gender.toString().isEmpty)) {
      debugPrint("null info");
      return false;
    } else {
      debugPrint("not null info");
      return true;
    }
  }

  Future<UserModel> getUser(String email) async {
    DocumentSnapshot snapshot = await users.doc(email).get();
    UserModel model = UserModel.fromJson(json.encode(snapshot.data()));
    return model;
  }

  Future<String?> uploadImage(File image, String child) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      TaskSnapshot snapshot = await storageRef.child(child).putFile(image);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }
}
