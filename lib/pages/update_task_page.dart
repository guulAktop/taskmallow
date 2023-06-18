import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';
import '../constants/task_situations_constants.dart';

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({super.key});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? selectedSituation = "done";

  TaskModel? taskModel;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController projectNameTextEditingController = TextEditingController();
  TextEditingController projectDescriptionTextEditingController = TextEditingController();

  UserModel? selectedUser;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskModel = getTaskModelFromArguments();
    if (taskModel != null) {
      selectedSituation = taskModel!.situation.name;
      projectNameTextEditingController.text = taskModel!.name;
      projectDescriptionTextEditingController.text = taskModel!.description;
      selectedUser = users.where((element) => element.email == taskModel!.collaboratorMail).first;
    } else {
      Navigator.pop(context);
    }
  }

  TaskModel? getTaskModelFromArguments() {
    ModalRoute? route = ModalRoute.of(context);
    dynamic arguments = route?.settings.arguments;
    if (arguments is TaskModel) {
      return arguments;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> situationDropdownItems = [];
    List<Widget> selectedSituationDropdownItems = [];

    for (String situation in TaskSituationsConstants().situations) {
      situationDropdownItems.add(getDropdownItem(getTranslated(context, situation), situation));
    }

    for (String situation in TaskSituationsConstants().situations) {
      selectedSituationDropdownItems.add(getDropdownSelectedItem(getTranslated(context, situation)));
    }

    List<DropdownMenuItem<UserModel>> userDropdownItems = [];
    List<Widget> selectedUserDropdownItems = [];

    for (UserModel user in users) {
      userDropdownItems.add(getDropdownUserItem(user.email, user));
    }

    for (UserModel user in users) {
      selectedUserDropdownItems.add(getDropdownSelectedUserItem(user));
    }

    return BaseScaffoldWidget(
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: "Update Task",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        PopupMenuWidget(
          menuList: generatePopup(),
        )
      ],
      widgetList: [
        Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormFieldComponent(
                context: context,
                textEditingController: projectNameTextEditingController,
                textCapitalization: TextCapitalization.words,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                hintText: "Task Name",
                keyboardType: TextInputType.text,
                maxCharacter: 50,
                validator: (text) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: itemBackgroundLightColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DropdownButton<String>(
                    value: selectedSituation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSituation = newValue;
                      });
                    },
                    autofocus: true,
                    items: situationDropdownItems,
                    selectedItemBuilder: (context) {
                      return selectedSituationDropdownItems;
                    },
                    underline: Container(),
                    iconEnabledColor: hintTextLightColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: IconComponent(iconData: CustomIconData.caretDown, color: primaryColor),
                    ),
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextComponent(
                          textAlign: TextAlign.center,
                          text: "Situation",
                          color: hintTextLightColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormFieldComponent(
                context: context,
                textEditingController: projectDescriptionTextEditingController,
                textCapitalization: TextCapitalization.sentences,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                hintText: "Description",
                keyboardType: TextInputType.text,
                maxLines: 5,
                validator: (text) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: itemBackgroundLightColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DropdownButton<UserModel>(
                    value: selectedUser,
                    onChanged: (UserModel? newValue) {
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    autofocus: true,
                    items: userDropdownItems,
                    selectedItemBuilder: (context) {
                      return selectedUserDropdownItems;
                    },
                    underline: Container(),
                    iconEnabledColor: hintTextLightColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: IconComponent(iconData: CustomIconData.caretDown, color: primaryColor),
                    ),
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextComponent(
                          textAlign: TextAlign.center,
                          text: "Collaboratos",
                          color: hintTextLightColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ButtonComponent(
                text: "Update",
                onPressed: () {
                  AppFunctions().showSnackbar(
                    context,
                    selectedUser != null ? selectedUser!.email : "Please select a user!",
                    icon: CustomIconData.taskmallow,
                    backgroundColor: primaryColor,
                  );
                  if (taskModel != null && selectedUser != null) {
                    setState(() {
                      taskModel!.collaboratorMail = selectedUser!.email;
                      Navigator.pop(context);
                    });
                  }
                },
                isWide: true,
                color: warningDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> getDropdownItem(String label, String value,
      {bool enabled = true, Color textColor = textPrimaryLightColor, FontWeight fontWeight = FontWeight.normal}) {
    return DropdownMenuItem<String>(
      enabled: enabled,
      value: value,
      child: TextComponent(
        headerType: enabled == false ? HeaderType.h5 : HeaderType.h6,
        text: label,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget getDropdownSelectedItem(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: TextComponent(
        text: label,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }

  List<List<PopupMenuWidgetItem>> generatePopup() {
    List<List<PopupMenuWidgetItem>> popupMenuList = [];
    popupMenuList.add([
      PopupMenuWidgetItem(
          title: "Delete Task",
          prefixIcon: CustomIconData.trashCan,
          color: dangerDark,
          function: () {
            AppFunctions().showSnackbar(
              context,
              selectedSituation.toString(),
              icon: CustomIconData.taskmallow,
              backgroundColor: primaryColor,
            );
          })
    ]);

    return popupMenuList;
  }
}

class UserModel {
  String email;
  String firstName;
  String lastName;
  String profilePhotoURL;
  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePhotoURL,
  });
}

DropdownMenuItem<UserModel> getDropdownUserItem(
  String label,
  UserModel user,
) {
  return DropdownMenuItem<UserModel>(
      value: user,
      child: Row(
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: CircularPhotoComponent(
              url: user.profilePhotoURL,
              hasBorder: false,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: TextComponent(
              text: user.email,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ));
}

Widget getDropdownSelectedUserItem(UserModel user) {
  return Container(
    padding: const EdgeInsets.only(left: 15),
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: CircularPhotoComponent(
            url: user.profilePhotoURL,
            hasBorder: false,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: TextComponent(
            text: user.email,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}
