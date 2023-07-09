import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({super.key});

  @override
  ConsumerState<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  bool _isLoading = false;
  String? _selectedCategory;

  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Widget> selectedDropdownItems = [];

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _projectNameTextEditingController = TextEditingController();
  final TextEditingController _projectDescriptionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
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
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.newProject),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => _isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    bool result = _checkInformations();
                    if (result && userRepository.userModel != null) {
                      ProjectModel project = ProjectModel(
                        name: _projectNameTextEditingController.text.trim(),
                        category: ProjectModel.getCategoryFromValue(_selectedCategory!),
                        description: _projectDescriptionTextEditingController.text.trim(),
                        userWhoCreated: UserModel.fromMap(userRepository.userModel!.toMap())..password = null,
                        collaborators: [UserModel.fromMap(userRepository.userModel!.toMap())..password = null],
                      );
                      await projectRepository.add(project).whenComplete(() {
                        Navigator.pushReplacementNamed(context, projectDetailPageRoute, arguments: projectRepository.projectModel);
                      });
                    }
                    setState(() {
                      _isLoading = false;
                    });
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
          textEditingController: _projectNameTextEditingController,
          textCapitalization: TextCapitalization.words,
          enabled: !_isLoading,
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
            enabled: !_isLoading,
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
}
