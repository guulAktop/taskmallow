import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/routes/route_constants.dart';

class UserRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference images = FirebaseFirestore.instance.collection('images');
  CollectionReference notificationTokens = FirebaseFirestore.instance.collection('notificationTokens');
  UserModel? userModel;
  bool isSucceeded = false;
  bool userInfoIsFull = false;
  List<UserModel> allUsers = [];

  Future<void> register(UserModel model) async {
    isSucceeded = false;
    await users.where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isEmpty) {
        await images.doc("profile").get().then((value) {
          model.profilePhotoURL = value.get("defaultProfilePhoto");
        });
        await users.doc(model.email).set(model.toMap()).then((value1) {
          debugPrint("User successfully added.");
          isSucceeded = true;
          userModel = model;
        }).catchError((error) {
          debugPrint("An error occurred while adding the user!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Current user!");
        isSucceeded = false;
      }
    });
    notifyListeners();
  }

  Future<void> login(UserModel model) async {
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
            userModel = UserModel.fromMap(value.docs[0].data());
          }
        });
      }
    });
    notifyListeners();
  }

  void logout(BuildContext context) {
    SharedPreferencesHelper.remove("loggedUser");
    Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
  }

  Future<void> getAllUsers() async {
    try {
      allUsers.clear();
      final QuerySnapshot querySnapshot = await users.get();
      allUsers = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }).toList();
      notifyListeners();
    } catch (error) {
      debugPrint("Projeler çekilirken bir hata oluştu!");
    }
  }

  Future<void> setLoggedUser() async {
    isSucceeded = false;
    await SharedPreferencesHelper.setString("loggedUser", jsonEncode(userModel!.toJson())).then((value) {
      isSucceeded = true;
    }).onError((error, stackTrace) {
      isSucceeded = false;
    });
    notifyListeners();
  }

  Future<void> update(UserModel user) async {
    isSucceeded = false;
    try {
      await getUser(user.email);
      user.joinDate = userModel?.joinDate;
      user.notificationToken = userModel?.notificationToken;
      user.password = userModel?.password;
    } catch (e) {
      debugPrint(e.toString());
    }
    await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await users.doc(user.email).update(user.toMap()).then((value1) {
          debugPrint("Profile updated.");
          isSucceeded = true;
          userModel = user;
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

  Future<void> deleteAccount(UserModel user) async {
    isSucceeded = false;
    final DocumentReference snapshot = users.doc(user.email);
    await snapshot.delete().then((value) {
      debugPrint("User successfully deleted.");
      isSucceeded = true;
      userModel = user;
    }).catchError((error) {
      debugPrint("An error occurred while deleting the User!");
      isSucceeded = false;
    });
    notifyListeners();
  }

  Future<void> updatePassword(UserModel user) async {
    isSucceeded = false;
    await users.where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await value.docs.first.reference.update({
          "password": user.password,
        }).then((value1) {
          debugPrint("Password updated.");
          isSucceeded = true;
          userModel = user;
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

  Future<bool> hasProfile(String email) async {
    QuerySnapshot snapshot = await users.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      debugPrint("no user");
      notifyListeners();
      return false;
    } else {
      debugPrint(snapshot.docs.first.data().toString());
      notifyListeners();
      return true;
    }
  }

  Future<void> userInfoFull(String email) async {
    userInfoIsFull = false;
    QuerySnapshot snapshot = await users.where('email', isEqualTo: email).get();
    var firstName = snapshot.docs[0].get("firstName");
    var lastName = snapshot.docs[0].get("lastName");
    var dateOfBirth = snapshot.docs[0].get("dateOfBirth");
    var gender = snapshot.docs[0].get("gender");

    if ((firstName == null || firstName.toString().isEmpty) ||
        (lastName == null || lastName.toString().isEmpty) ||
        (dateOfBirth == null || dateOfBirth.toString().isEmpty) ||
        (gender == null || gender.toString().isEmpty)) {
      debugPrint("null info");
      userInfoIsFull = false;
    } else {
      debugPrint("not null info");
      userInfoIsFull = true;
    }
    notifyListeners();
  }

  Future<void> updateNotificationToken(String notificationToken) async {
    isSucceeded = false;
    await notificationTokens.doc(userModel!.email).set({'notificationToken': notificationToken});
    await users.where('email', isEqualTo: userModel!.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await users.doc(userModel!.email).update({
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
    notifyListeners();
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
