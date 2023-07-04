import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/models/invitation_model.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/routes/route_constants.dart';

class UserRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  CollectionReference images = FirebaseFirestore.instance.collection('images');
  CollectionReference notificationTokens = FirebaseFirestore.instance.collection('notificationTokens');
  UserModel? userModel;
  UserModel? selectedUserModel;
  bool isSucceeded = false;
  bool userInfoIsFull = false;
  bool isLoading = false;
  List<ProjectModel> selectedUserProjects = [];
  List<ProjectModel> filteredProjects = [];
  List<UserModel> filteredUsers = [];
  List<InvitationModel> incomingInvitations = [];
  List<InvitationModel> outgoingInvitations = [];

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
          debugPrint("ERROR: UserRepository.register()\n$error");
          isSucceeded = false;
        });
      } else {
        isSucceeded = false;
      }
    });
    notifyListeners();
  }

  Future<void> login(UserModel model) async {
    await users.where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
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

  Future<void> setLoggedUser() async {
    isSucceeded = false;
    await SharedPreferencesHelper.setString("loggedUser", jsonEncode(userModel!.toJson())).then((value) {
      isSucceeded = true;
    }).onError((error, stackTrace) {
      debugPrint("ERROR: UserRepository.register()\n$error");
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
    } catch (error) {
      debugPrint("ERROR: UserRepository.update().getUser()\n$error");
    }
    await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await users.doc(user.email).update(user.toMap()).then((value1) {
          isSucceeded = true;
          userModel = user;
        }).catchError((error) {
          debugPrint("ERROR: UserRepository.update()\n$error");
          isSucceeded = false;
        });
      }
    });
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    isSucceeded = false;
    if (userModel != null) {
      final DocumentReference snapshot = users.doc(userModel!.email);
      await snapshot.delete().then((value) {
        isSucceeded = true;
        userModel = null;
      }).catchError((error) {
        debugPrint("ERROR: UserRepository.deleteAccount()\n$error");
        isSucceeded = false;
      });
      notifyListeners();
    }
  }

  Future<void> updatePassword(UserModel user) async {
    isSucceeded = false;
    await users.where('email', isEqualTo: user.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await value.docs.first.reference.update({
          "password": user.password,
        }).then((value1) {
          isSucceeded = true;
          userModel = user;
        }).catchError((error) {
          debugPrint("ERROR: UserRepository.updatePassword()\n$error");
          isSucceeded = false;
        });
      }
    });
    notifyListeners();
  }

  Future<void> getUser(String email) async {
    DocumentSnapshot snapshot = await users.doc(email).get();
    userModel = UserModel.fromJson(json.encode(snapshot.data()));
    notifyListeners();
  }

  Future<void> getSelectedUserByEmail(String email) async {
    DocumentSnapshot snapshot = await users.doc(email).get();
    selectedUserModel = UserModel.fromJson(json.encode(snapshot.data()));
    notifyListeners();
  }

  Future<void> getSelectedUserProjects() async {
    try {
      selectedUserProjects.clear();
      final QuerySnapshot querySnapshot = await projects.get();
      final List<ProjectModel> projectsList = querySnapshot.docs.map((doc) => ProjectModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
      final String selectedUserEmail = selectedUserModel!.email;
      final List<ProjectModel> matchingProjects =
          projectsList.where((project) => !project.isDeleted && project.collaborators.any((user) => user.email == selectedUserEmail)).toList();
      selectedUserProjects.addAll(matchingProjects);
      notifyListeners();
    } catch (error) {
      debugPrint("ERROR: UserRepository.getSelectedUserProjects()\n$error");
    }
  }

  Future<bool> hasProfile(String email) async {
    QuerySnapshot snapshot = await users.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      notifyListeners();
      return false;
    } else {
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
      userInfoIsFull = false;
    } else {
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
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("ERROR: UserRepository.updateNotificationToken()\n$error");
          isSucceeded = false;
        });
      }
    });
    notifyListeners();
  }

  Future<String?> uploadImage(File image, String child) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      TaskSnapshot snapshot = await storageRef.child(child).putFile(image);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint("ERROR: UserRepository.updateNotificationToken()\n${error.message}");
      return null;
    }
  }

  Future<void> searchUserAndProject(String searchText) async {
    filteredUsers.clear();
    filteredProjects.clear();
    notifyListeners();

    if (searchText.length > 2) {
      isLoading = true;
      await FirebaseFirestore.instance.collection('users').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          UserModel searchedUserModel = UserModel.fromMap(doc.data());
          if (filteredUsers.where((element) => element.email == searchedUserModel.email).isEmpty) {
            if (searchedUserModel.email.toLowerCase().split("@")[0].contains(searchText) ||
                searchedUserModel.firstName.toLowerCase().contains(searchText) ||
                searchedUserModel.lastName.toLowerCase().contains(searchText) ||
                ("${searchedUserModel.firstName} ${searchedUserModel.lastName}").toLowerCase().contains(searchText)) {
              filteredUsers.add(searchedUserModel);
            }
          }
        }
        notifyListeners();
      });

      await FirebaseFirestore.instance.collection('projects').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          ProjectModel searchedProjectModel = ProjectModel.fromMap(doc.data());
          if (filteredProjects.where((element) => element.name == searchedProjectModel.name).isEmpty && !searchedProjectModel.isDeleted) {
            if (searchedProjectModel.name.toLowerCase().contains(searchText) ||
                searchedProjectModel.description.toLowerCase().contains(searchText) ||
                searchedProjectModel.userWhoCreated.email.toLowerCase().contains(searchText) ||
                searchedProjectModel.userWhoCreated.firstName.toLowerCase().contains(searchText) ||
                searchedProjectModel.userWhoCreated.lastName.toLowerCase().contains(searchText) ||
                ("${searchedProjectModel.userWhoCreated.firstName} ${searchedProjectModel.userWhoCreated.lastName}").toLowerCase().contains(searchText)) {
              filteredProjects.add(ProjectModel.fromMap(doc.data()));
            }
          }
        }
        notifyListeners();
      });
    }
    isLoading = false;
  }

  Future<void> sendInvitation(InvitationModel invitationModel) async {
    isSucceeded = false;
    final databaseReference = FirebaseDatabase.instance.ref();
    try {
      final DatabaseReference inviteRef = databaseReference.child('invitations').push();
      final invitationId = inviteRef.key;
      invitationModel.id = invitationId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final invitationData = invitationModel.toMap();

      await inviteRef.set(invitationData).then((value) {
        isSucceeded = true;
      }).onError((error, stackTrace) {
        isSucceeded = false;
      });
    } catch (error) {
      debugPrint("ERROR: UserRepository.sendInvitation()\n$error");
      isSucceeded = false;
    }
    notifyListeners();
  }

  Future<void> removeInvitation(InvitationModel invitationModel) async {
    isSucceeded = false;
    try {
      final databaseReference = FirebaseDatabase.instance.ref();
      await databaseReference.child('invitations').child(invitationModel.id).remove().whenComplete(() {
        incomingInvitations.removeWhere((element) => element.id == invitationModel.id);
        outgoingInvitations.removeWhere((element) => element.id == invitationModel.id);
        debugPrint("successfully removed");
      });
    } catch (error) {
      debugPrint("ERROR: UserRepository.removeInvitation()\n$error");
      isSucceeded = false;
    }
    notifyListeners();
  }

  Future<void> listenInvitations() async {
    incomingInvitations.clear();
    outgoingInvitations.clear();
    if (userModel != null) {
      final databaseReference = FirebaseDatabase.instance.ref();
      final query = databaseReference.child('invitations').orderByChild('fromUser/email').equalTo(userModel!.email);
      query.onValue.listen((event) {
        outgoingInvitations.clear();
        final DataSnapshot dataSnapshot = event.snapshot;
        final dynamic dataSnapshotValue = dataSnapshot.value;
        if (dataSnapshotValue != null && dataSnapshotValue is Map<dynamic, dynamic>) {
          final Map<dynamic, dynamic> invitationsData = dataSnapshotValue;
          invitationsData.forEach((key, value) {
            final InvitationModel invitation = InvitationModel.fromMap(value as Map<dynamic, dynamic>);
            outgoingInvitations.add(invitation);
          });
        } else {
          debugPrint('Davet bulunamadı');
        }
        notifyListeners();
      }, onError: (error) {
        debugPrint("ERROR: getInvitations()\n$error");
      });

      final query2 = databaseReference.child('invitations').orderByChild('toUser/email').equalTo(userModel!.email);
      query2.onValue.listen((event) {
        incomingInvitations.clear();
        final DataSnapshot dataSnapshot = event.snapshot;
        final dynamic dataSnapshotValue = dataSnapshot.value;
        if (dataSnapshotValue != null && dataSnapshotValue is Map<dynamic, dynamic>) {
          final Map<dynamic, dynamic> invitationsData = dataSnapshotValue;
          invitationsData.forEach((key, value) {
            final InvitationModel invitation = InvitationModel.fromMap(value as Map<dynamic, dynamic>);
            incomingInvitations.add(invitation);
          });
        } else {
          debugPrint('Davet bulunamadı');
        }
        incomingInvitations.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        notifyListeners();
      }, onError: (error) {
        debugPrint("ERROR: getInvitations()\n$error");
      });
    }
  }
}
