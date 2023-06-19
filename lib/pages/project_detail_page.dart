import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/task_situations_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> with TickerProviderStateMixin {
  bool isLoading = false;
  TabController? tabController;
  int _selectedTab = 0;

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

  List<TaskModel> tasks = [
    TaskModel(
      taskId: "T1",
      name: "LoginPage UI tasarımı kodlanacak.",
      description: "LoginPage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.to_do,
      collaboratorMail: "enescerrahoglu1@gmail.com",
    ),
    TaskModel(
      taskId: "T2",
      name: "RegisterPage UI tasarımı kodlanacak.",
      description: "RegisterPage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.to_do,
      collaboratorMail: "gul.aktopp@gmail.com",
    ),
    TaskModel(
      taskId: "T3",
      name: "HomePage UI tasarımı kodlanacak.",
      description: "HomePage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.done,
      collaboratorMail: "ozdamarsevval.01@gmail.com",
    ),
    TaskModel(
      taskId: "T4",
      name: "SettingsPage UI tasarımı kodlanacak.",
      description: "SettingsPage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.done,
      collaboratorMail: "enescerrahoglu1@gmail.com",
    ),
    TaskModel(
      taskId: "T5",
      name: "ProfilePage UI tasarımı kodlanacak.",
      description: "ProfilePage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.to_do,
      collaboratorMail: "msalihgirgin@gmail.com",
    ),
    TaskModel(
      taskId: "T6",
      name: "ProjectsPage UI tasarımı kodlanacak.",
      description: "ProjectsPage UI tasarımı Figma'da yer alan tasarıma uygun şekilde kodlanacak.",
      situation: TaskSituation.in_progress,
      collaboratorMail: "izzetjmy@gmail.com",
    ),
  ];

  late ProjectModel projectModel;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    projectModel = ProjectModel(
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
      tasks: tasks,
      collaborators: users,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Project Page",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, createTaskPageRoute);
          },
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.squarePlus),
        ),
      ],
      widgetList: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextComponent(
                    text: projectModel.name,
                    headerType: HeaderType.h4,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, updateProjectPageRoute, arguments: projectModel);
                  },
                  splashRadius: AppConstants.iconSplashRadius,
                  icon: const IconComponent(iconData: CustomIconData.penCircle, color: primaryColor),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextComponent(
                  text: projectModel.description,
                  textAlign: TextAlign.start,
                  headerType: HeaderType.h6,
                ),
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
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextComponent(
                  text: "${(tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length * 100).toStringAsFixed(0)}% Complete",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  headerType: HeaderType.h7,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: LinearProgressIndicator(
                    minHeight: 20,
                    value: (tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length).toDouble(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextComponent(
                  text: "Collaborators",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: users
                        .map((user) => Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularPhotoComponent(url: user.profilePhotoURL, hasBorder: false),
                                  ),
                                  TextComponent(
                                    text: user.firstName[0] + user.lastName[0],
                                    headerType: HeaderType.h6,
                                  )
                                ],
                              ),
                            ))
                        .toList()
                      ..add(
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              child: Material(
                                color: primaryColor,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, collaboratorsPageRoute);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const IconComponent(
                                      iconData: CustomIconData.plus,
                                      color: textPrimaryDarkColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: secondaryColor, thickness: 1),
            ),
            Center(
              child: TabBar(
                onTap: (value) {
                  setState(() {
                    _selectedTab = value;
                  });
                  debugPrint(_selectedTab.toString());
                },
                splashBorderRadius: const BorderRadius.all(Radius.circular(50)),
                physics: const BouncingScrollPhysics(),
                controller: tabController,
                labelColor: primaryColor,
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextComponent(text: getTranslated(context, TaskSituation.to_do.name)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextComponent(text: getTranslated(context, TaskSituation.in_progress.name)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextComponent(text: getTranslated(context, TaskSituation.done.name)),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (_selectedTab == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: tasks.where((element) => element.situation == TaskSituation.to_do).map((e) => getTaskRow(e)).toList(),
                    ),
                  );
                } else if (_selectedTab == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: tasks.where((element) => element.situation == TaskSituation.in_progress).map((e) => getTaskRow(e)).toList(),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: tasks.where((element) => element.situation == TaskSituation.done).map((e) => getTaskRow(e)).toList(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ],
    );
  }

  Widget getTaskRow(TaskModel taskModel) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, updateTaskPageRoute, arguments: taskModel);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                TextComponent(
                  text: taskModel.taskId,
                  color: primaryColor,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MarqueeWidget(
                    child: TextComponent(
                      text: taskModel.name,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      softWrap: true,
                      maxLines: 1,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: PopupMenuWidget(
                    menuList: generatePopup(taskModel),
                  ),
                ),
              ],
            ),
            TextComponent(
              text: taskModel.description,
              textAlign: TextAlign.start,
              headerType: HeaderType.h6,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularPhotoComponent(
                      url: users.where((element) => element.email == taskModel.collaboratorMail).first.profilePhotoURL, hasBorder: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<List<PopupMenuWidgetItem>> generatePopup(TaskModel taskModel) {
    List<List<PopupMenuWidgetItem>> popupMenuList = [];
    List<PopupMenuWidgetItem> menuList = [];

    taskModel.situation.name != TaskSituation.to_do.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.to_do.name),
              prefixIcon: CustomIconData.list,
              color: primaryColor,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.to_do;
                });
              },
            ),
          )
        : null;

    taskModel.situation.name != TaskSituation.in_progress.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.in_progress.name),
              prefixIcon: CustomIconData.spinner,
              color: warningDark,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.in_progress;
                });
              },
            ),
          )
        : null;

    taskModel.situation.name != TaskSituation.done.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.done.name),
              prefixIcon: CustomIconData.circleCheck,
              color: success,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.done;
                });
              },
            ),
          )
        : null;

    popupMenuList.add(menuList);
    return popupMenuList;
  }
}

class TaskModel {
  String taskId;
  String name;
  String description;
  TaskSituation situation;
  String collaboratorMail;

  TaskModel({
    required this.taskId,
    required this.name,
    required this.description,
    required this.situation,
    required this.collaboratorMail,
  });
}

class ProjectModel {
  String name;
  String description;
  Categories category;
  UserModel userWhoCreated;
  List<TaskModel> tasks;
  List<UserModel> collaborators;

  ProjectModel({
    required this.name,
    required this.description,
    required this.category,
    required this.userWhoCreated,
    required this.tasks,
    required this.collaborators,
  });
}

class InvitationModel {
  String id;
  ProjectModel projectModel;
  String to;

  InvitationModel({
    required this.id,
    required this.projectModel,
    required this.to,
  });
}
