import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';

class ProjectRepository extends ChangeNotifier {
  CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  ProjectModel? projectModel;
  List<ProjectModel> allProjects = [];
  List<ProjectModel> allProjectsInvolved = [];
  List<ProjectModel> allPreferredProjects = [];
  bool isSucceeded = false;
  bool isLoading = true;

  Future<void> add(ProjectModel project) async {
    isSucceeded = false;
    try {
      final DocumentReference docRef = await projects.add(project.toMap());
      final String projectId = docRef.id;
      project = (project..id = projectId);
      await projects.doc(projectId).set((project).toMap());
      projectModel = project;
      allProjects.add(project);
      allProjectsInvolved.insert(0, project);
      notifyListeners();
      debugPrint('Proje başarıyla eklendi. Belge Kimliği: $projectId');
      isSucceeded = true;
    } catch (error) {
      debugPrint('Proje eklenirken hata oluştu: $error');
      isSucceeded = false;
    }
  }

  Future<void> update(ProjectModel project) async {
    isSucceeded = false;
    try {
      final String projectId = project.id;
      await projects.doc(projectId).update(project.toMap());
      projectModel = project;
      if (project.isDeleted) {
        allProjects.removeWhere((element) => element.id == project.id);
        allProjectsInvolved.removeWhere((element) => element.id == project.id);
        allPreferredProjects.removeWhere((element) => element.id == project.id);
      } else {
        allProjects.removeWhere((element) => element.id == project.id);
        allProjectsInvolved.removeWhere((element) => element.id == project.id);
        allPreferredProjects.removeWhere((element) => element.id == project.id);
        allProjects.add(project);
        allPreferredProjects.add(project);
        allProjectsInvolved.add(project);
        allProjectsInvolved.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
      }
      debugPrint('Proje başarıyla güncellendi. Belge Kimliği: $projectId');
      isSucceeded = true;
      notifyListeners();
    } catch (error) {
      debugPrint('Proje güncellenirken hata oluştu: $error');
      isSucceeded = false;
    }
  }

  Future<void> delete(ProjectModel project) async {
    isSucceeded = false;
    final DocumentReference snapshot = projects.doc(project.id);
    await snapshot.delete().then((value) {
      allProjects.removeWhere((element) => element.id == project.id);
      allProjectsInvolved.removeWhere((element) => element.id == project.id);
      debugPrint("Project successfully deleted.");
      isSucceeded = true;
    }).catchError((error) {
      debugPrint("An error occurred while deleting the project!");
      isSucceeded = false;
    });
    notifyListeners();
  }

  Future<void> getAllProjects() async {
    try {
      allProjects.clear();
      final QuerySnapshot querySnapshot = await projects.get();
      allProjects = querySnapshot.docs
          .map((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final ProjectModel project = ProjectModel.fromMap(data);
            if (!project.isDeleted) {
              return ProjectModel.fromMap(data);
            }
          })
          .whereType<ProjectModel>()
          .toList();
      notifyListeners();
    } catch (error) {
      debugPrint("Projeler çekilirken bir hata oluştu!");
    }
  }

  Future<void> getAllPreferredProjects(UserModel userModel) async {
    try {
      allPreferredProjects.clear();
      final QuerySnapshot querySnapshot = await projects.get();
      final List<ProjectModel> preferredProjects = querySnapshot.docs
          .map((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final ProjectModel project = ProjectModel.fromMap(data);
            if (!project.isDeleted) {
              return ProjectModel.fromMap(data);
            }
          })
          .whereType<ProjectModel>()
          .toList();

      final List<String> preferredCategories = userModel.preferredCategories;
      for (final ProjectModel project in preferredProjects) {
        if (preferredCategories.contains(project.category.name)) {
          allPreferredProjects.add(project);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint("Projeler çekilirken bir hata oluştu!");
    }
  }

  Future<void> getAllProjectsInvolved(UserModel userModel) async {
    try {
      allProjectsInvolved.clear();
      for (final ProjectModel project in allProjects) {
        final List<String> collaboratorEmails = project.collaborators.map((collaborator) => collaborator.email).toList();
        if (collaboratorEmails.contains(userModel.email)) {
          allProjectsInvolved.add(project);
        }
      }
      allProjectsInvolved.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
      notifyListeners();
    } catch (error) {
      debugPrint("Dahil olunan projeler çekilirken bir hata oluştu!");
    }
  }

  Future<void> getProjectById(String projectId) async {
    try {
      final DocumentSnapshot projectSnapshot = await projects.doc(projectId).get();
      if (projectSnapshot.exists) {
        final ProjectModel project = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
        final String userEmail = project.userWhoCreated.email;
        final DocumentSnapshot userSnapshot = await users.doc(userEmail).get();

        if (userSnapshot.exists) {
          final UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
          final List<UserModel> collaborators = await _fetchCollaborators(project.collaborators);
          projectModel = project.copyWith(
            userWhoCreated: user,
            collaborators: collaborators,
          );
          debugPrint('Collaborator bilgileri güncellendi.');
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    notifyListeners();
  }

  Future<List<UserModel>> _fetchCollaborators(List<UserModel> collaborators) async {
    final List<UserModel> currentCollaborators = [];
    try {
      for (final UserModel collaborator in collaborators) {
        final DocumentSnapshot collaboratorSnapshot = await users.doc(collaborator.email).get();
        if (collaboratorSnapshot.exists) {
          final UserModel currentCollaborator = UserModel.fromMap(collaboratorSnapshot.data() as Map<String, dynamic>);
          currentCollaborators.add(currentCollaborator..password = null);
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
        await projects.doc(projectModel!.id).update(projectModel!.toMap());
        allProjects.removeWhere((element) => element.id == projectModel!.id);
        allProjects.add(projectModel!);
        allProjectsInvolved.removeWhere((element) => element.id == projectModel!.id);
        allProjectsInvolved.add(projectModel!);
        allProjectsInvolved.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        debugPrint('Task başarıyla eklendi. Belge Kimliği: ${projectModel!.id}');
        isSucceeded = true;
        notifyListeners();
      }
    } catch (error) {
      projectModel!.tasks.removeWhere((element) => element.id == task.id);
      notifyListeners();
      debugPrint('Task eklenirken hata oluştu: $error');
      isSucceeded = false;
    }
  }
}
