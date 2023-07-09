import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class UpdateProjectPage extends ConsumerStatefulWidget {
  const UpdateProjectPage({super.key});

  @override
  ConsumerState<UpdateProjectPage> createState() => _UpdateProjectPageState();
}

class _UpdateProjectPageState extends ConsumerState<UpdateProjectPage> {
  bool isLoading = false;
  String? _selectedCategory;
  ProjectModel? projectModel;
  final TextEditingController _projectNameTextEditingController = TextEditingController();
  final TextEditingController _projectDescriptionTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    projectModel = getProjectModelFromArguments();
    if (projectModel != null) {
      _selectedCategory = projectModel!.category.name;
      _projectNameTextEditingController.text = projectModel!.name;
      _projectDescriptionTextEditingController.text = projectModel!.description;
    } else {
      Navigator.pop(context);
    }
  }

  ProjectModel? getProjectModelFromArguments() {
    ModalRoute? route = ModalRoute.of(context);
    dynamic arguments = route?.settings.arguments;
    if (arguments is ProjectModel) {
      return arguments;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    List<Widget> selectedDropdownItems = [];
    for (String title in CategoryConstants().titles) {
      dropdownItems.add(getDropdownItem(getTranslated(context, title), title, enabled: false, textColor: primaryColor, fontWeight: FontWeight.bold));
      for (String subtitle in CategoryConstants().subtitleMap[title]!) {
        dropdownItems.add(getDropdownItem(getTranslated(context, subtitle), subtitle));
      }
    }

    for (String title in CategoryConstants().titles) {
      selectedDropdownItems.add(getDropdownSelectedItem(getTranslated(context, title)));
      for (String subtitle in CategoryConstants().subtitleMap[title]!) {
        selectedDropdownItems.add(getDropdownSelectedItem(getTranslated(context, subtitle)));
      }
    }

    ProjectRepository projectRepository = ref.watch(projectProvider);
    return BaseScaffoldWidget(
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.updateProject),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        PopupMenuWidget(
          menuList: generatePopup(projectRepository),
        )
      ],
      widgetList: [
        TextFormFieldComponent(
          context: context,
          textEditingController: _projectNameTextEditingController,
          textCapitalization: TextCapitalization.words,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          hintText: getTranslated(context, AppKeys.projectName),
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
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              autofocus: true,
              items: dropdownItems,
              selectedItemBuilder: (context) {
                return selectedDropdownItems;
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
                    text: getTranslated(context, AppKeys.category),
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
            textEditingController: _projectDescriptionTextEditingController,
            textCapitalization: TextCapitalization.sentences,
            enabled: !isLoading,
            textInputAction: TextInputAction.newline,
            hintText: getTranslated(context, AppKeys.description),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxCharacter: 10000,
            validator: (text) {
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        ButtonComponent(
          text: getTranslated(context, AppKeys.update),
          onPressed: () async {
            bool value = _checkInformations();
            if (value && projectModel != null) {
              setState(() {
                isLoading = true;
              });
              projectModel!.name = _projectNameTextEditingController.text.trim();
              projectModel!.description = _projectDescriptionTextEditingController.text.trim();
              projectModel!.category = ProjectModel.getCategoryFromValue(_selectedCategory!);
              await projectRepository.update(projectModel!).whenComplete(() {
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              });
            }
          },
          isWide: true,
          color: warningDark,
        ),
      ],
    );
  }

  bool _checkInformations() {
    if (_projectNameTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterProjectName), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (_selectedCategory == null) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.selectCategory), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (_projectDescriptionTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterDescription), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else {
      return true;
    }
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

  List<List<PopupMenuWidgetItem>> generatePopup(ProjectRepository projectRepository) {
    List<List<PopupMenuWidgetItem>> popupMenuList = [];
    popupMenuList.add(
      [
        PopupMenuWidgetItem(
          title: getTranslated(context, AppKeys.deleteProject),
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
                            content:
                                TextComponent(text: getTranslated(context, AppKeys.aysDeleteProject), textAlign: TextAlign.start, headerType: HeaderType.h5),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text(getTranslated(context, AppKeys.yes)),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (projectModel != null) {
                                    await projectRepository.update(projectModel!..isDeleted = true).whenComplete(() {
                                      projectRepository.updateProjectInAllLists();
                                      Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
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
          },
        ),
      ],
    );
    return popupMenuList;
  }
}
