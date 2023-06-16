import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/constants/task_situations_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? selectedSituation;

  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Widget> selectedDropdownItems = [];

  @override
  void initState() {
    super.initState();
  }

  TextEditingController projectNameTextEditingController = TextEditingController();
  TextEditingController projectDescriptionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    List<Widget> selectedDropdownItems = [];

    for (String situation in TaskSituationsConstants().situations) {
      dropdownItems.add(getDropdownItem(getTranslated(context, situation), situation));
    }

    for (String situation in TaskSituationsConstants().situations) {
      selectedDropdownItems.add(getDropdownSelectedItem(getTranslated(context, situation)));
    }

    return BaseScaffoldWidget(
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: "New Task",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: TextButton(
            onPressed: () {
              AppFunctions().showSnackbar(
                context,
                selectedSituation.toString(),
                icon: CustomIconData.taskmallow,
                backgroundColor: primaryColor,
              );
            },
            child: TextComponent(
              maxLines: 1,
              text: getTranslated(context, AppKeys.done),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
}
