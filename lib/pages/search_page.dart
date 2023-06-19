import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  final TextEditingController _searchTextEditingController = TextEditingController();

  List<UserModel> users = [
    UserModel(
        email: "enescerrahoglu1@gmail.com",
        firstName: "Enes",
        lastName: "Cerrahoğlu",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
    UserModel(
        email: "gul.aktopp@gmail.com",
        firstName: "Gülsüm",
        lastName: "Aktop",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fg%C3%BCl.jpg?alt=media&token=4d5b013c-30c5-4ce4-a5c7-01a3c7b0ac38"),
    UserModel(
        email: "ozdamarsevval.01@gmail.com",
        firstName: "Şevval",
        lastName: "Özdamar",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2F%C5%9Fevval.jpg?alt=media&token=bafb43ec-1dd3-4233-9619-9b1ed3e26189"),
    UserModel(
        email: "izzetjmy@gmail.com",
        firstName: "İzzet",
        lastName: "Jumayev",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fizzet.jpg?alt=media&token=4e7aef85-9d1d-4cfd-9e2e-58388b6bbe4e"),
    UserModel(
        email: "msalihgirgin@gmail.com",
        firstName: "Muhammed Salih",
        lastName: "Girgin",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fsalih.jpg?alt=media&token=7034fffb-51e0-4dac-9f00-498d9939be4a"),
  ];

  List<ProjectModel> projects = [
    ProjectModel(
      name: "Taskmallow",
      category: Categories.mobile_applications,
      description:
          "TaskMallow, iş yönetimi ve inovasyonu bir araya getiren yenilikçi bir uygulamadır. Projelerinizi yönetmek, görevleri takip etmek, yaratıcı fikirler geliştirmek ve eşleşme özelliğiyle en uygun görevleri bulmak için tasarlanmıştır.",
      userWhoCreated: UserModel(
          email: "enescerrahoglu1@gmail.com",
          firstName: "Enes",
          lastName: "Cerrahoğlu",
          profilePhotoURL:
              "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
      tasks: [],
      collaborators: [],
    ),
    ProjectModel(
      name: "Tesla",
      category: Categories.mobile_applications,
      description: "Lorem ipsum dolor sit amet.",
      userWhoCreated: UserModel(
          email: "ozdamarsevval.01@gmail.com",
          firstName: "Şevval",
          lastName: "Özdamar",
          profilePhotoURL:
              "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2F%C5%9Fevval.jpg?alt=media&token=bafb43ec-1dd3-4233-9619-9b1ed3e26189"),
      tasks: [],
      collaborators: [],
    ),
    ProjectModel(
      name: "Gül Aktop",
      category: Categories.mobile_applications,
      description: "Lorem ipsum dolor sit amet.",
      userWhoCreated: UserModel(
          email: "gul.aktopp@gmail.com",
          firstName: "Gülsüm",
          lastName: "Aktop",
          profilePhotoURL:
              "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fg%C3%BCl.jpg?alt=media&token=4d5b013c-30c5-4ce4-a5c7-01a3c7b0ac38"),
      tasks: [],
      collaborators: [],
    ),
  ];

  List<UserModel> filteredUsers = [];
  List<ProjectModel> filteredProjects = [];

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Search",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      widgetList: [
        TextFormFieldComponent(
          context: context,
          textEditingController: _searchTextEditingController,
          iconData: CustomIconData.magnifyingGlass,
          hintText: "Search",
          onChanged: (text) {
            setState(
              () {
                if (text.isEmpty) {
                  filteredUsers.clear();
                } else {
                  filteredUsers = users
                      .where((user) =>
                          user.firstName.toLowerCase().contains(text.toLowerCase()) ||
                          user.lastName.toLowerCase().contains(text.toLowerCase()) ||
                          user.email.toLowerCase().contains(text.toLowerCase()) ||
                          ("${user.firstName} ${user.lastName}").toLowerCase().contains(text.toLowerCase()))
                      .toList();

                  filteredProjects = projects
                      .where((project) =>
                          project.name.toLowerCase().contains(text.toLowerCase()) ||
                          project.description.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.email.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.firstName.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.lastName.toLowerCase().contains(text.toLowerCase()) ||
                          ("${project.userWhoCreated.firstName} ${project.userWhoCreated.lastName}").toLowerCase().contains(text.toLowerCase()))
                      .toList();
                }
              },
            );
          },
        ),
        Visibility(
          visible: _searchTextEditingController.text.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextComponent(
                text: filteredUsers.isNotEmpty ? "Users" : "User not found!",
                color: filteredUsers.isNotEmpty ? textPrimaryLightColor : danger,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              Column(
                children: filteredUsers.map((user) => getUserRow(user)).toList(),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _searchTextEditingController.text.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextComponent(
                text: filteredProjects.isNotEmpty ? "Projects" : "Project not found!",
                color: filteredProjects.isNotEmpty ? textPrimaryLightColor : danger,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              Column(
                children: filteredProjects.map((project) => getProjectRow(project)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getUserRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pushNamed(context, profileScreenPageRoute);
        },
        child: Row(
          children: [
            SizedBox(
              width: UIHelper.getDeviceWidth(context) / 7,
              height: UIHelper.getDeviceWidth(context) / 7,
              child: CircularPhotoComponent(
                url: user.profilePhotoURL,
                hasBorder: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                    child: TextComponent(
                      text: "${user.firstName} ${user.lastName}",
                      fontWeight: FontWeight.bold,
                      headerType: HeaderType.h4,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  MarqueeWidget(
                    child: TextComponent(
                      text: user.email,
                      headerType: HeaderType.h7,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProjectRow(ProjectModel projectModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pushNamed(context, updateProjectPageRoute);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextComponent(
              text: projectModel.name,
              headerType: HeaderType.h4,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            TextComponent(
              text: projectModel.description,
              textAlign: TextAlign.start,
              headerType: HeaderType.h6,
            ),
            const SizedBox(height: 10),
            const TextComponent(
              text:
                  "33% Complete", //"${(tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length * 100).toStringAsFixed(0)}% Complete",
              textAlign: TextAlign.start,
              overflow: TextOverflow.fade,
              softWrap: true,
              headerType: HeaderType.h7,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: LinearProgressIndicator(
                minHeight: 20,
                value: (0.33).toDouble(),
              ),
            ),
            const SizedBox(height: 10),
            TextComponent(
              text: "created by ${projectModel.userWhoCreated.email}",
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.end,
              overflow: TextOverflow.fade,
              softWrap: true,
              headerType: HeaderType.h7,
            ),
          ],
        ),
      ),
    );
  }
}
