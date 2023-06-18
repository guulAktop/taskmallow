import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/constants/task_situations_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../components/icon_component.dart';
import '../constants/app_constants.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  bool isLoading = false;

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

  late ProjectModel projectModel1;
  late ProjectModel projectModel2;

  List<InvitationModel>? invitations = [];

  @override
  void initState() {
    super.initState();
    projectModel1 = ProjectModel(
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

    projectModel2 = ProjectModel(
      name: "Proje 2",
      category: Categories.mobile_applications,
      description:
          "TaskMallow, iş yönetimi ve inovasyonu bir araya getiren yenilikçi bir uygulamadır. Projelerinizi yönetmek, görevleri takip etmek, yaratıcı fikirler geliştirmek ve eşleşme özelliğiyle en uygun görevleri bulmak için tasarlanmıştır.",
      userWhoCreated: UserModel(
          email: "msalihgirgin@gmail.com",
          firstName: "Muhammed Salih",
          lastName: "Girgin",
          profilePhotoURL:
              "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fsalih.jpg?alt=media&token=7034fffb-51e0-4dac-9f00-498d9939be4a"),
      tasks: tasks,
      collaborators: users,
    );
    invitations = [
      InvitationModel(id: DateTime.now().microsecond.toString(), projectModel: projectModel1, to: "gul.aktopp@gmail.com"),
      InvitationModel(id: DateTime.now().microsecond.toString(), projectModel: projectModel2, to: "gul.aktopp@gmail.com"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.invitations),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: invitations!.map((invitation) => getInvitationRow(invitation)).toList(),
    );
  }

  Widget getInvitationRow(InvitationModel invitationModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${invitationModel.projectModel.userWhoCreated.firstName} ${invitationModel.projectModel.userWhoCreated.lastName}",
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint("${invitationModel.projectModel.userWhoCreated.firstName} ${invitationModel.projectModel.userWhoCreated.lastName}");
                    },
                ),
                TextSpan(
                  text: getTranslated(context, AppKeys.invitationMessagePart1),
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                ),
                TextSpan(
                  text: invitationModel.projectModel.name,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint(invitationModel.projectModel.name);
                    },
                ),
                TextSpan(
                  text: getTranslated(context, AppKeys.invitationMessagePart2),
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ButtonComponent(
                  text: getTranslated(context, AppKeys.accept),
                  textPadding: 8,
                  isOutLined: true,
                  color: success,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  child: ButtonComponent(
                    text: getTranslated(context, AppKeys.reject),
                    textPadding: 8,
                    isOutLined: true,
                    color: danger,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
