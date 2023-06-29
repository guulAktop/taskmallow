import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:uuid/uuid.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  bool isLoading = false;
  String? _selectedSituation;

  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Widget> selectedDropdownItems = [];

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _taskNameTextEditingController = TextEditingController();
  final TextEditingController _taskDescriptionTextEditingController = TextEditingController();

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

    ProjectRepository projectRepository = ref.watch(projectProvider);
    return BaseScaffoldWidget(
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.newTask),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: TextButton(
            onPressed: () async {
              var uuid = const Uuid();

              bool value = _checkInformations();
              if (value) {
                setState(() {
                  isLoading = true;
                });
                TaskModel taskModel = TaskModel(
                  id: uuid.v1(),
                  viewId: "T${ref.watch(projectProvider).projectModel!.tasks.length + 1}",
                  name: _taskNameTextEditingController.text.trim(),
                  description: _taskDescriptionTextEditingController.text.trim(),
                  situation: TaskModel.getTaskSituationFromValue(_selectedSituation!),
                );
                await projectRepository.addTask(taskModel).whenComplete(() {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                });
              }
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
