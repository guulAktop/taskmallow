import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _surnameEditingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  final TextEditingController _dateofBirthEditingController =
      TextEditingController();
  final TextEditingController _genderEditingController =
      TextEditingController();
  final TextEditingController _linkedinLinkEditingController =
      TextEditingController();
  final TextEditingController _twitterLinkEditingController =
      TextEditingController();

  final _editProfileFormKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  final String circleavatarImage = "AAA";

  @override
  void dispose() {
    _nameEditingController.dispose();
    _surnameEditingController.dispose();
    _bioEditingController.dispose();
    _dateofBirthEditingController.dispose();
    _genderEditingController.dispose();
    _linkedinLinkEditingController.dispose();
    _twitterLinkEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.editProfile),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(
            iconData: CustomIconData.chevronLeft, color: Colors.black),
        onPressed: () => _isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () {},
            child: Text(
              getTranslated(context, AppKeys.done),
              style: const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      widgetList: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _editProfileFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor,
                  child: Text(circleavatarImage),
                ),
                const SizedBox(height: 30),
                textAndTextFormField(context, _nameEditingController,
                    getTranslated(context, AppKeys.name)),
                textAndTextFormField(context, _surnameEditingController,
                    getTranslated(context, AppKeys.surname)),
                textAndTextFormField(context, _bioEditingController,
                    getTranslated(context, AppKeys.bio)),
                textAndTextFormField(context, _dateofBirthEditingController,
                    getTranslated(context, AppKeys.dateofBirth)),
                textAndTextFormField(context, _genderEditingController,
                    getTranslated(context, AppKeys.gender)),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getTranslated(context, AppKeys.links),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                linksTextFormField(context, _linkedinLinkEditingController,
                    "www.linkedin.com/in/"),
                const SizedBox(height: 6),
                linksTextFormField(
                    context, _twitterLinkEditingController, "www.twitter.com"),
              ],
            ),
          ),
        ),
        const Spacer()
      ],
    );
  }
}

textAndTextFormField(BuildContext context,
    TextEditingController textEditingController, String info) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(info,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      TextFormFieldComponent(
        context: context,
        textEditingController: textEditingController,
      ),
      const SizedBox(height: 5)
    ],
  );
}

linksTextFormField(BuildContext context,
    TextEditingController textEditingController, String info) {
  return Container(
    width: UIHelper.getDeviceWidth(context),
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: containerColor,
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            info,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Expanded(
          child: TextFormFieldComponent(
              context: context, textEditingController: textEditingController),
        ),
      ],
    ),
  );
}
