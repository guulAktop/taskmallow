import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/models/invitation_model.dart';
import 'package:taskmallow/models/message_model.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/repositories/user_repository.dart';

class ProjectRepository extends ChangeNotifier {
  CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  ProjectModel? projectModel;
  List<ProjectModel> allRelatedProjects = [];
  List<ProjectModel> latestProjects = [];
  List<ProjectModel> favoriteProjects = [];
  List<ProjectModel> matchingProjects = [];
  List<UserModel> matchingUsers = [];
  bool isSucceeded = false;
  bool isLoading = false;
  List<InvitationModel> invitations = [];
  List<MessageModel> projectMessages = [];

  Future<void> add(ProjectModel project) async {
    isSucceeded = false;
    try {
      final DocumentReference docRef = await projects.add(project.toMap());
      final String projectId = docRef.id;
      project = (project..id = projectId);
      await projects.doc(projectId).set((project).toMap()).whenComplete(() {
        projectModel = project;
        allRelatedProjects.insert(0, project);
        latestProjects.insert(0, project);
        if (project.userWhoCreated.preferredCategories.contains(project.category.name)) {
          matchingProjects.add(project);
        }
        notifyListeners();
      });
      isSucceeded = true;
    } catch (error) {
      isSucceeded = false;
      debugPrint("ERROR: ProjectRepository.add()\n$error");
    }
  }

  Future<void> update(ProjectModel project) async {
    isSucceeded = false;
    try {
      final String projectId = project.id;
      await projects.doc(projectId).update(project.toMap()).whenComplete(() {
        projectModel = project;
        updateProjectInAllLists();
        isSucceeded = true;
      });
    } catch (error) {
      isSucceeded = false;
      debugPrint("ERROR: ProjectRepository.update()\n$error");
    }
  }

  Future<void> getMatchingProjects(UserModel userModel) async {
    try {
      matchingProjects.clear();
      final QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).get();
      final List<ProjectModel> allProjects = querySnapshot.docs
          .map((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final ProjectModel project = ProjectModel.fromMap(data);
            if (!project.isDeleted && !project.collaborators.any((element) => element.email == userModel.email)) {
              if (project.tasks.isEmpty ||
                  project.tasks.where((task) => task.isDeleted == false).where((element) => element.situation == TaskSituation.done).length !=
                      project.tasks.where((task) => task.isDeleted == false).length) {
                return project;
              }
            }
          })
          .whereType<ProjectModel>()
          .toList();

      final List<String> preferredCategories = userModel.preferredCategories;
      for (final project in allProjects) {
        if (preferredCategories.contains(project.category.name)) {
          matchingProjects.add(project);
        }
      }
      matchingProjects = matchingProjects.getRange(0, matchingProjects.length > 5 ? 5 : matchingProjects.length).toList();
      notifyListeners();
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getMatchingProjects()\n$error");
    }
  }

  Future<void> getMatchingUsers() async {
    try {
      matchingUsers.clear();
      List<Map<String, dynamic>> analyticUsers = [];
      if (projectModel != null) {
        final QuerySnapshot querySnapshot = await users.where('preferredCategories', arrayContains: projectModel!.category.name).get();
        final List<UserModel> preferredUsers = querySnapshot.docs
            .map((doc) {
              final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              final UserModel user = UserModel.fromMap(data);
              return user;
            })
            .whereType<UserModel>()
            .toList();

        for (final user in preferredUsers) {
          if (!projectModel!.collaborators.any((element) => element.email == user.email)) {
            var result = await getUserAnalytics(user);
            analyticUsers.add({"user": user, "score": ((result["relatedProjects"] as int) * (result["completedTasks"] as int))});
          }
        }

        analyticUsers.sort((a, b) => b["score"].compareTo(a["score"]));
        for (var i = 0; i < analyticUsers.length && i < 5; i++) {
          UserModel user = analyticUsers[i]["user"];
          matchingUsers.add(user);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getMatchingUsers()\n$error");
    }
  }

  Future<Map<String, dynamic>> getUserAnalytics(UserModel userModel) async {
    List<ProjectModel> userRelatedProjects = [];
    try {
      userRelatedProjects.clear();
      final QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).get();
      userRelatedProjects = querySnapshot.docs
          .map((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final ProjectModel project = ProjectModel.fromMap(data);

            final List<String> collaboratorEmails = project.collaborators.map((collaborator) => collaborator.email).toList();
            if (!project.isDeleted && collaboratorEmails.contains(userModel.email)) {
              return project;
            }
          })
          .whereType<ProjectModel>()
          .toList();
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getUserAnalytics()\n$error");
    }
    return {
      "relatedProjects": userRelatedProjects.length,
      "completedTasks": userRelatedProjects
          .expand((project) => project.tasks)
          .where((task) => !task.isDeleted && task.situation == TaskSituation.done && task.assignedUserMail == userModel.email)
          .length,
    };
  }

  Future<void> getAllRelatedProjects(UserModel userModel) async {
    try {
      allRelatedProjects.clear();
      final QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).orderBy('createdDate', descending: true).get();
      allRelatedProjects = querySnapshot.docs
          .map((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final ProjectModel project = ProjectModel.fromMap(data);

            final List<String> collaboratorEmails = project.collaborators.map((collaborator) => collaborator.email).toList();
            if (!project.isDeleted && collaboratorEmails.contains(userModel.email)) {
              return project;
            }
          })
          .whereType<ProjectModel>()
          .toList();
      updateProjectInAllLists();
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getAllRelatedProjects()\n$error");
    }
  }

  Future<void> getProject(String projectId) async {
    try {
      final DocumentSnapshot projectSnapshot = await projects.doc(projectId).get();
      if (projectSnapshot.exists) {
        ProjectModel project = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
        final DocumentSnapshot userSnapshot = await users.doc(project.userWhoCreated.email).get();

        for (var task in project.tasks) {
          if (!project.collaborators.any((element) => element.email == task.assignedUserMail)) {
            project = project..tasks.where((element) => element.assignedUserMail == task.assignedUserMail).first.assignedUserMail = null;
          }
        }

        if (userSnapshot.exists) {
          final UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>)..password = null;
          final List<UserModel> collaborators = await _fetchCollaborators(project.collaborators);
          projectModel = project.copyWith(
            userWhoCreated: user,
            collaborators: collaborators,
          );
          listenForInvitationsByProject();
        }
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getProject()\n$error");
    }
    notifyListeners();
  }

  Future<ProjectModel> getProjectById(String projectId) async {
    final DocumentSnapshot projectSnapshot = await projects.doc(projectId).get();
    if (projectSnapshot.exists) {
      ProjectModel project = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
      final DocumentSnapshot userSnapshot = await users.doc(project.userWhoCreated.email).get();

      for (var task in project.tasks) {
        if (!project.collaborators.any((element) => element.email == task.assignedUserMail)) {
          project = project..tasks.where((element) => element.assignedUserMail == task.assignedUserMail).first.assignedUserMail = null;
        }
      }

      if (userSnapshot.exists) {
        final UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>)..password = null;
        final List<UserModel> collaborators = await _fetchCollaborators(project.collaborators);
        project = project.copyWith(
          userWhoCreated: user,
          collaborators: collaborators,
        );
      }
      return project;
    } else {
      throw Exception('Davet bulunamadı');
    }
  }

  Future<List<UserModel>> _fetchCollaborators(List<UserModel> collaborators) async {
    final List<UserModel> currentCollaborators = [];
    try {
      for (final UserModel collaborator in collaborators) {
        final DocumentSnapshot collaboratorSnapshot = await users.doc(collaborator.email).get();
        if (collaboratorSnapshot.exists) {
          final UserModel currentCollaborator = UserModel.fromMap(collaboratorSnapshot.data() as Map<String, dynamic>)..password = null;
          currentCollaborators.add(currentCollaborator);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return currentCollaborators;
  }

  Future<void> addTask(TaskModel task) async {
    isSucceeded = false;
    try {
      if (projectModel != null) {
        projectModel!.tasks.add(task);
        await projects.doc(projectModel!.id).update(projectModel!.toMap()).whenComplete(() {
          updateProjectInAllLists();
          isSucceeded = true;
        });
      }
    } catch (error) {
      updateProjectInAllLists();
      debugPrint("ERROR: ProjectRepository.addTask()\n$error");
      isSucceeded = false;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    isSucceeded = false;
    try {
      if (projectModel != null) {
        final int index = projectModel!.tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          await projects.doc(projectModel!.id).update(projectModel!.toMap()).whenComplete(() {
            updateProjectInAllLists();
          });
        }
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.updateTask()\n$error");
      isSucceeded = false;
    }
  }

  updateProjectInAllLists() {
    if (projectModel != null) {
      if (projectModel!.isDeleted) {
        favoriteProjects.removeWhere((element) => element.id == projectModel!.id);
        latestProjects.removeWhere((element) => element.id == projectModel!.id);
        allRelatedProjects.removeWhere((element) => element.id == projectModel!.id);
        matchingProjects.removeWhere((element) => element.id == projectModel!.id);
        return;
      }

      int latestIndex = latestProjects.indexWhere((item) => item.id == projectModel!.id);
      if (latestIndex != -1 && !projectModel!.isDeleted) {
        latestProjects[latestIndex] = projectModel!;
      }

      int involvedIndex = allRelatedProjects.indexWhere((item) => item.id == projectModel!.id);
      if (involvedIndex != -1 && !projectModel!.isDeleted) {
        allRelatedProjects[involvedIndex] = projectModel!;
      }

      int preferredIndex = matchingProjects.indexWhere((item) => item.id == projectModel!.id);
      if (preferredIndex != -1 && !projectModel!.isDeleted) {
        matchingProjects[preferredIndex] = projectModel!;
      }

      int favoriteIndex = favoriteProjects.indexWhere((item) => item.id == projectModel!.id);
      if (favoriteIndex != -1 && !projectModel!.isDeleted) {
        favoriteProjects[favoriteIndex] = projectModel!;
      }
    }
    notifyListeners();
  }

  Future<void> getLatestProjects() async {
    try {
      latestProjects.clear();
      notifyListeners();
      QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).orderBy('createdDate', descending: true).limit(20).get();
      for (var doc in querySnapshot.docs) {
        ProjectModel project = ProjectModel.fromMap(doc.data() as Map<String, dynamic>);
        latestProjects.add(project);
        notifyListeners();
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getLatestProjects()\n$error");
    }
  }

  Future<void> getFavoriteProjects(UserModel user) async {
    try {
      for (String projectId in user.favoriteProjects) {
        DocumentSnapshot projectSnapshot = await projects.doc(projectId).get();
        if (projectSnapshot.exists) {
          ProjectModel project = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
          if (!project.isDeleted && !favoriteProjects.any((element) => element.id == project.id)) {
            favoriteProjects.add(project);
          }
        }
        notifyListeners();
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getFavoriteProjects()\n$error");
    }
  }

  Future<void> getInvitationsByProject(ProjectModel project) async {
    invitations.clear();
    try {
      final databaseReference = FirebaseDatabase.instance.ref();
      final DatabaseEvent event = await databaseReference.child('invitations').orderByChild('project/id').equalTo(project.id).once();
      final DataSnapshot dataSnapshot = event.snapshot;
      final dynamic dataSnapshotValue = dataSnapshot.value;

      if (dataSnapshotValue != null && dataSnapshotValue is Map<dynamic, dynamic>) {
        final Map<dynamic, dynamic> invitationsData = dataSnapshotValue;
        invitations.clear();
        invitationsData.forEach((key, value) {
          final InvitationModel invitation = InvitationModel.fromMap(value as Map<String, dynamic>);
          invitations.add(invitation);
        });
        debugPrint('Davetler: $invitations');
      } else {
        debugPrint('Davet bulunamadı');
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.getInvitationsByProject()\n$error");
    }
    notifyListeners();
  }

  Future<void> listenForInvitationsByProject() async {
    try {
      invitations.clear();
      if (projectModel != null) {
        projectModel = await getProjectById(projectModel!.id);
        final databaseReference = FirebaseDatabase.instance.ref();
        final query = databaseReference.child('invitations').orderByChild('project/id').equalTo(projectModel!.id);
        query.onValue.listen((event) {
          invitations.clear();
          final DataSnapshot dataSnapshot = event.snapshot;
          final dynamic dataSnapshotValue = dataSnapshot.value;
          if (dataSnapshotValue != null && dataSnapshotValue is Map<dynamic, dynamic>) {
            final Map<dynamic, dynamic> invitationsData = dataSnapshotValue;
            invitationsData.forEach((key, value) async {
              final InvitationModel invitation = InvitationModel.fromMap(value as Map<dynamic, dynamic>);
              if (invitation.project.id == projectModel!.id &&
                  !projectModel!.isDeleted &&
                  invitation.project.userWhoCreated.email == invitation.fromUser.email) {
                if (projectModel!.collaborators.any((element) => element.email == invitation.toUser.email) &&
                    projectModel!.collaborators.any((element) => element.email == invitation.fromUser.email)) {
                  UserRepository userRepository = UserRepository();
                  await userRepository.removeInvitation(invitation);
                } else {
                  invitations.add(invitation);
                }
              }
            });
            debugPrint('Güncellenmiş Davetler: $invitations');
          } else {
            debugPrint('Davet bulunamadı');
          }
          notifyListeners();
        }, onError: (error) {
          debugPrint("ERROR: ProjectRepository.listenForInvitationsByProject()\n$error");
        });
      }
    } catch (e) {
      throw Exception([e]);
    }
  }

  Future<void> addCollaborator(ProjectModel project, UserModel userModel) async {
    try {
      final DocumentSnapshot projectSnapshot = await projects.doc(project.id).get();
      if (projectSnapshot.exists) {
        final ProjectModel currentProject = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
        if (!currentProject.collaborators.any((element) => element.email == userModel.email)) {
          currentProject.collaborators.add(userModel..password = null);
          await projects.doc(project.id).update(currentProject.toMap()).whenComplete(() {
            projectModel = currentProject;
            int involvedIndex = allRelatedProjects.indexWhere((item) => item.id == currentProject.id);
            if (involvedIndex == -1 && !currentProject.isDeleted) {
              allRelatedProjects.insert(0, currentProject);
            }
            updateProjectInAllLists();
          });
        }
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.addCollaborator()\n$error");
    }
    notifyListeners();
  }

  Future<void> removeCollaborator(ProjectModel project, UserModel userModel) async {
    try {
      final DocumentSnapshot projectSnapshot = await projects.doc(project.id).get();
      if (projectSnapshot.exists) {
        final ProjectModel currentProject = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
        if (currentProject.collaborators.any((element) => element.email == userModel.email)) {
          currentProject.collaborators.removeWhere((element) => element.email == userModel.email);
          await projects.doc(project.id).update(currentProject.toMap()).whenComplete(() {
            projectModel = currentProject;
            int involvedIndex = allRelatedProjects.indexWhere((item) => item.id == currentProject.id);
            if (involvedIndex == -1 && !currentProject.isDeleted) {
              allRelatedProjects.insert(0, currentProject);
            }
            updateProjectInAllLists();
          });
        }
      }
    } catch (error) {
      debugPrint("ERROR: ProjectRepository.removeCollaborator()\n$error");
    }
    notifyListeners();
  }

  Future<void> listenForProjectMessages() async {
    try {
      projectMessages.clear();
      if (projectModel != null) {
        final databaseReference = FirebaseDatabase.instance.ref();
        final query = databaseReference.child('projectMessages').child(projectModel!.id).orderByKey();
        query.onValue.listen((event) {
          projectMessages.clear();
          final DataSnapshot dataSnapshot = event.snapshot;
          final dynamic dataSnapshotValue = dataSnapshot.value;
          if (dataSnapshotValue != null && dataSnapshotValue is Map<dynamic, dynamic>) {
            final Map<dynamic, dynamic> projectMessagesData = dataSnapshotValue;
            projectMessagesData.forEach((key, value) {
              final MessageModel messageModel = MessageModel.fromMap(value as Map<dynamic, dynamic>);
              projectMessages.add(messageModel);
            });
            debugPrint('Güncel Mesajlar: $projectMessages');
          } else {
            debugPrint('Mesaj bulunamadı');
          }
          projectMessages.sort((a, b) => a.messageDate.compareTo(b.messageDate));
          notifyListeners();
        }, onError: (error) {
          debugPrint("ERROR: ProjectRepository.listenForMessagesByProject()\n$error");
        });
      }
    } catch (e) {
      throw Exception([e]);
    }
  }
}
