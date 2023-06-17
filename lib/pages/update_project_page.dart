import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class UpdateProjectPage extends StatefulWidget {
  const UpdateProjectPage({super.key});

  @override
  State<UpdateProjectPage> createState() => _UpdateProjectPageState();
}

class _UpdateProjectPageState extends State<UpdateProjectPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? selectedCategory = "artificial_intelligence";

  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Widget> selectedDropdownItems = [];
  ProjectModel? projectModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    projectModel = getProjectModelFromArguments();
    if (projectModel != null) {
      selectedCategory = projectModel!.category.name;
      projectNameTextEditingController.text = projectModel!.name;
      projectDescriptionTextEditingController.text = projectModel!.description;
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

  TextEditingController projectNameTextEditingController = TextEditingController();
  TextEditingController projectDescriptionTextEditingController = TextEditingController();

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
    return BaseScaffoldWidget(
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: "Update Project",
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
                hintText: "Project Name",
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
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
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
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextComponent(
                          textAlign: TextAlign.center,
                          text: "Category",
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
              ButtonComponent(
                text: "Update",
                onPressed: () {
                  AppFunctions().showSnackbar(context, selectedCategory.toString());
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
    popupMenuList.add([PopupMenuWidgetItem(title: "Delete Project", prefixIcon: CustomIconData.trashCan, color: dangerDark, function: () {})]);

    return popupMenuList;
  }
}
