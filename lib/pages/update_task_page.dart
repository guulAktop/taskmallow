import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
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
  String? selectedSituation;

  TaskModel? taskModel;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController projectNameTextEditingController = TextEditingController();
  TextEditingController projectDescriptionTextEditingController = TextEditingController();

  UserModel? selectedUser;

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
      title: getTranslated(context, AppKeys.updateTask),
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
                hintText: getTranslated(context, AppKeys.taskName),
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
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextComponent(
                          textAlign: TextAlign.center,
                          text: getTranslated(context, AppKeys.situation),
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
                hintText: getTranslated(context, AppKeys.description),
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
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextComponent(
                          textAlign: TextAlign.center,
                          text: getTranslated(context, AppKeys.collaborators),
                          color: hintTextLightColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ButtonComponent(
                text: getTranslated(context, AppKeys.update),
                onPressed: () {
                  AppFunctions().showSnackbar(
                    context,
                    selectedUser != null ? selectedUser!.email : getTranslated(context, AppKeys.pleaseSelectCollaborator),
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
          title: getTranslated(context, AppKeys.deleteTask),
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
