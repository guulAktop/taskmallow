import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class UpdateTaskPage extends ConsumerStatefulWidget {
  const UpdateTaskPage({super.key});

  @override
  ConsumerState<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends ConsumerState<UpdateTaskPage> {
  bool isLoading = false;
  String? _selectedSituation;
  TaskModel? taskModel;

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _taskNameTextEditingController = TextEditingController();
  final TextEditingController _taskDescriptionTextEditingController = TextEditingController();

  UserModel? _selectedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskModel = getTaskModelFromArguments();
    if (taskModel != null) {
      _selectedSituation = taskModel!.situation.name;
      _taskNameTextEditingController.text = taskModel!.name;
      _taskDescriptionTextEditingController.text = taskModel!.description;
      if (taskModel!.assignedUserMail != null && taskModel!.assignedUserMail!.isNotEmpty) {
        _selectedUser = ref.watch(projectProvider).projectModel!.collaborators.firstWhere((element) => element.email == taskModel!.assignedUserMail!);
      }
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

    for (UserModel user in ref.watch(projectProvider).projectModel!.collaborators) {
      userDropdownItems.add(getDropdownUserItem(user.email, user));
    }

    for (UserModel user in ref.watch(projectProvider).projectModel!.collaborators) {
      selectedUserDropdownItems.add(getDropdownSelectedUserItem(user));
    }

    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);

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
          menuList: generatePopup(projectRepository, taskModel),
        )
      ],
      widgetList: [
        TextFormFieldComponent(
          context: context,
          textEditingController: _taskNameTextEditingController,
          textCapitalization: TextCapitalization.sentences,
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
              value: _selectedSituation,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSituation = newValue;
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
        Expanded(
          child: TextFormFieldComponent(
            context: context,
            textEditingController: _taskDescriptionTextEditingController,
            textCapitalization: TextCapitalization.sentences,
            enabled: !isLoading,
            textInputAction: TextInputAction.newline,
            hintText: getTranslated(context, AppKeys.description),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            validator: (text) {
              return null;
            },
          ),
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
              value: _selectedUser,
              onChanged: (UserModel? newValue) {
                setState(() {
                  _selectedUser = newValue;
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
          onPressed: () async {
            bool value = _checkInformations();
            if (value && taskModel != null) {
              taskModel!.name = _taskNameTextEditingController.text.trim();
              taskModel!.situation = TaskModel.getTaskSituationFromValue(_selectedSituation!);
              taskModel!.description = _taskDescriptionTextEditingController.text.trim();
              taskModel!.assignedUserMail = _selectedUser?.email;
              await projectRepository.updateTask(taskModel!).whenComplete(() async {
                if (taskModel!.assignedUserMail != null) {
                  UserModel user = await userRepository.getUserByEmail(taskModel!.assignedUserMail!);
                  String title = await AppFunctions().getTranslatedByLocale(user.languageCode ?? "en", AppKeys.taskHasBeenAssigned);
                  String body1 = await AppFunctions().getTranslatedByLocale(user.languageCode ?? "en", AppKeys.taskHasBeenAssignedDetail1);
                  String body2 = await AppFunctions().getTranslatedByLocale(user.languageCode ?? "en", AppKeys.taskHasBeenAssignedDetail2);
                  String body3 = await AppFunctions().getTranslatedByLocale(user.languageCode ?? "en", AppKeys.taskHasBeenAssignedDetail3);
                  await AppFunctions().sendPushMessage(user, title, "$body1${taskModel!.viewId}$body2${projectRepository.projectModel!.name}$body3");
                }
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
          },
          isWide: true,
          color: warningDark,
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

  List<List<PopupMenuWidgetItem>> generatePopup(ProjectRepository projectRepository, TaskModel? taskModel) {
    List<List<PopupMenuWidgetItem>> popupMenuList = [];
    popupMenuList.add([
      PopupMenuWidgetItem(
          title: getTranslated(context, AppKeys.deleteTask),
          prefixIcon: CustomIconData.trashCan,
          color: dangerDark,
          function: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                barrierDismissible: !isLoading,
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                  builder: (context, setState) => WillPopScope(
                    onWillPop: () async => !isLoading,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CupertinoAlertDialog(
                            content: TextComponent(text: getTranslated(context, AppKeys.aysDeleteTask), textAlign: TextAlign.start, headerType: HeaderType.h5),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text(getTranslated(context, AppKeys.yes)),
                                onPressed: () async {
                                  if (taskModel != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    taskModel.isDeleted = true;
                                    await projectRepository.updateTask(taskModel).whenComplete(() {
                                      Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
                                      Navigator.pushNamed(context, projectDetailPageRoute, arguments: projectRepository.projectModel);
                                    });
                                  }
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text(getTranslated(context, AppKeys.no)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          })
    ]);
    return popupMenuList;
  }

  bool _checkInformations() {
    if (_taskNameTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterTaskName), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (_selectedSituation == null) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.selectSituation), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (_taskDescriptionTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterDescription), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else {
      return true;
    }
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
    ),
  );
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
