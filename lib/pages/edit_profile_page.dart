import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? pickedImage;
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _bioTextEditingController = TextEditingController();
  final TextEditingController _dateOfBirthTextEditingController = TextEditingController();
  final TextEditingController _linkedinTextEditingController = TextEditingController();
  final TextEditingController _twitterTextEditingController = TextEditingController();

  bool isLoading = false;
  final _loginFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthTextEditingController.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      key: _scaffoldKey,
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.editProfile),
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
                selectedGender.toString(),
                icon: CustomIconData.earthAmericas,
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
        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
            child: SizedBox(
              height: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
              width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  AppFunctions().showMediaSnackbar(context, () {
                    AppFunctions().pickImageFromCamera().then((file) {
                      setState(() => pickedImage = file);
                    });
                  }, () {
                    AppFunctions().pickImageFromGallery().then((file) {
                      setState(() => pickedImage = file);
                    });
                  });
                },
                child: pickedImage == null
                    ? CircularPhotoComponent(
                        url: ImageAssetKeys.defaultProfilePhotoUrl,
                      )
                    : CircularPhotoComponent(
                        image: pickedImage,
                      ),
              ),
            ),
          ),
        ),
        Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormFieldComponent(
                context: context,
                textEditingController: _emailTextEditingController,
                hintText: getTranslated(context, AppKeys.email),
                readOnly: true,
                validator: (emailText) {
                  if (emailText!.isEmpty) {
                    AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterFirstName),
                        backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.firstName),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: _firstNameTextEditingController,
                textCapitalization: TextCapitalization.words,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                hintText: getTranslated(context, AppKeys.firstName),
                maxCharacter: 20,
                validator: (firstNameText) {
                  if (firstNameText!.trim().isEmpty) {
                    AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterFirstName),
                        backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.lastName),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: _lastNameTextEditingController,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                hintText: getTranslated(context, AppKeys.lastName),
                maxCharacter: 20,
                validator: (lastNameText) {
                  if (_firstNameTextEditingController.text.trim().isNotEmpty) {
                    if (lastNameText!.trim().isEmpty) {
                      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterLastName),
                          backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                      return "";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.bio),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: _bioTextEditingController,
                hintText: getTranslated(context, AppKeys.bio),
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                maxCharacter: 20,
                keyboardType: TextInputType.name,
                validator: (bioText) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.dateOfBirth),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: _dateOfBirthTextEditingController,
                hintText: getTranslated(context, AppKeys.dateOfBirth),
                enabled: !isLoading,
                maxCharacter: 20,
                keyboardType: TextInputType.name,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (dateText) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.gender),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: itemBackgroundLightColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: DropdownButton<int>(
                    value: selectedGender,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem<int>(
                        value: 0,
                        child: TextComponent(
                          text: getTranslated(context, AppKeys.male),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: TextComponent(
                          text: getTranslated(context, AppKeys.female),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: TextComponent(
                          text: getTranslated(context, AppKeys.iDoNotWantToSpecify),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                    underline: Container(),
                    iconEnabledColor: hintTextLightColor,
                    isExpanded: true,
                    icon: const IconComponent(iconData: CustomIconData.caretDown, color: primaryColor),
                    hint: TextComponent(
                      text: getTranslated(context, AppKeys.gender),
                      color: hintTextLightColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, AppKeys.links),
                    headerType: HeaderType.h7,
                    color: textPrimaryLightColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                prefixText: "www.linkedin.com/in/",
                textEditingController: _linkedinTextEditingController,
                hintText: "username",
                enabled: !isLoading,
                maxCharacter: 20,
                keyboardType: TextInputType.name,
                validator: (dateText) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormFieldComponent(
                context: context,
                prefixText: "twitter.com/",
                textEditingController: _twitterTextEditingController,
                hintText: "username",
                enabled: !isLoading,
                maxCharacter: 20,
                keyboardType: TextInputType.name,
                validator: (dateText) {
                  return null;
                },
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
