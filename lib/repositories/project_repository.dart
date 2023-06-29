import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';

class ProjectRepository extends ChangeNotifier {
  CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  ProjectModel? projectModel;
  List<ProjectModel> allRelatedProjects = [];
  List<ProjectModel> allPreferredProjects = [];
  List<ProjectModel> latestProjects = [];
  bool isSucceeded = false;
  bool isLoading = false;

  Future<void> add(ProjectModel project) async {
    isSucceeded = false;
    try {
      final DocumentReference docRef = await projects.add(project.toMap());
      final String projectId = docRef.id;
      project = (project..id = projectId);
      await projects.doc(projectId).set((project).toMap()).whenComplete(() {
        projectModel = project;
        allRelatedProjects.insert(0, project);
        if (project.userWhoCreated.preferredCategories.contains(project.category.name)) {
          allPreferredProjects.add(project);
        }
        notifyListeners();
      });
      isSucceeded = true;
    } catch (error) {
      isSucceeded = false;
    }
  }

  Future<void> update(ProjectModel project) async {
    isSucceeded = false;
    try {
      final String projectId = project.id;
      await projects.doc(projectId).update(project.toMap());
      projectModel = project;
      updateProjectInAllLists();
      isSucceeded = true;
    } catch (error) {
      isSucceeded = false;
    }
  }

  Future<void> getAllPreferredProjects(UserModel userModel) async {
    try {
      allPreferredProjects.clear();
      final QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).orderBy('createdDate', descending: true).get();
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
      debugPrint("Dahil olunan projeler çekilirken bir hata oluştu!");
    }
  }

  Future<void> getProjectById(String projectId) async {
    try {
      final DocumentSnapshot projectSnapshot = await projects.doc(projectId).get();
      if (projectSnapshot.exists) {
        final ProjectModel project = ProjectModel.fromMap(projectSnapshot.data() as Map<String, dynamic>);
        final DocumentSnapshot userSnapshot = await users.doc(project.userWhoCreated.email).get();

        if (userSnapshot.exists) {
          final UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>)..password = null;
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
      debugPrint('Task eklenirken hata oluştu: $error');
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
      debugPrint('Task güncellenirken hata oluştu: $error');
      isSucceeded = false;
    }
  }

  updateProjectInAllLists() {
    if (projectModel != null) {
      if (projectModel!.isDeleted) {
        latestProjects.removeWhere((element) => element.id == projectModel!.id);
        allRelatedProjects.removeWhere((element) => element.id == projectModel!.id);
        allPreferredProjects.removeWhere((element) => element.id == projectModel!.id);
        return;
      }

      int involvedIndex = allRelatedProjects.indexWhere((item) => item.id == projectModel!.id);
      if (involvedIndex != -1 && !projectModel!.isDeleted) {
        allRelatedProjects[involvedIndex] = projectModel!;
      }

      int preferredIndex = allPreferredProjects.indexWhere((item) => item.id == projectModel!.id);
      if (preferredIndex != -1 && !projectModel!.isDeleted) {
        allPreferredProjects[preferredIndex] = projectModel!;
      }
    }
    notifyListeners();
  }

  Future<void> getLatestProjects() async {
    latestProjects.clear();
    try {
      QuerySnapshot querySnapshot = await projects.where('isDeleted', isEqualTo: false).orderBy('createdDate', descending: true).limit(20).get();
      for (var doc in querySnapshot.docs) {
        ProjectModel project = ProjectModel.fromMap(doc.data() as Map<String, dynamic>);
        latestProjects.add(project);
      }
    } catch (e) {
      debugPrint('Error fetching latest projects: $e');
    }
  }
}
