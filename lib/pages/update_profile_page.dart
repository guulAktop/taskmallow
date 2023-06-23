import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/services/user_service.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  File? pickedImage;
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _descriptionTextEditingController = TextEditingController();
  final TextEditingController _dateOfBirthTextEditingController = TextEditingController();
  final TextEditingController _linkedinTextEditingController = TextEditingController();
  final TextEditingController _twitterTextEditingController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserService userService = UserService();
  late UserModel loggedUser;
  bool isLoading = false;
  final _loginFormKey = GlobalKey<FormState>();
  int? selectedGender;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: UIHelper.getDeviceHeight(context) / 2.5,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime:
                _dateOfBirthTextEditingController.text.isEmpty ? DateTime.now() : DateFormat("dd.MM.yyyy").parse(_dateOfBirthTextEditingController.text),
            minimumYear: 1900,
            maximumYear: DateTime.now().year,
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
                _dateOfBirthTextEditingController.text =
                    '${newDate.day.toString().padLeft(2, '0')}.${newDate.month.toString().padLeft(2, '0')}.${newDate.year}';
              });
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pickedImage = null;
    loggedUser = ref.read(loggedUserProvider)!;
    _emailTextEditingController.text = loggedUser.email.toString();
    loggedUser.firstName != null ? _firstNameTextEditingController.text = loggedUser.firstName.toString() : null;
    loggedUser.lastName != null ? _lastNameTextEditingController.text = loggedUser.lastName.toString() : null;
    loggedUser.description != null ? _descriptionTextEditingController.text = loggedUser.description.toString() : null;
    loggedUser.dateOfBirth != null ? selectedDate = loggedUser.dateOfBirth : null;
    loggedUser.gender != null ? selectedGender = loggedUser.gender : null;
    loggedUser.linkedinProfileURL != null ? _linkedinTextEditingController.text = loggedUser.linkedinProfileURL.toString() : null;
    loggedUser.twitterProfileURL != null ? _twitterTextEditingController.text = loggedUser.twitterProfileURL.toString() : null;
    if (selectedDate != null) {
      _dateOfBirthTextEditingController.text =
          '${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    int? arg = ModalRoute.of(context)!.settings.arguments as int?;
    return BaseScaffoldWidget(
      key: _scaffoldKey,
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.editProfile),
      leadingWidget: arg == 1
          ? null
          : IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(
                iconData: CustomIconData.chevronLeft,
              ),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
      actionList: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: TextButton(
            onPressed: isLoading
                ? null
                : () async {
                    bool result = _checkInformations();
                    if (result) {
                      setState(() {
                        isLoading = true;
                      });
                      if (pickedImage != null) {
                        loggedUser.profilePhotoURL = await userService.uploadImage(
                            pickedImage!, "ProfilePhotos/${loggedUser.email}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
                      }
                      loggedUser.firstName = _firstNameTextEditingController.text.trim();
                      loggedUser.lastName = _lastNameTextEditingController.text.trim();
                      loggedUser.description = _descriptionTextEditingController.text.trim();
                      loggedUser.dateOfBirth = selectedDate;
                      loggedUser.gender = selectedGender;
                      loggedUser.linkedinProfileURL = _linkedinTextEditingController.text.trim();
                      loggedUser.twitterProfileURL = _twitterTextEditingController.text.trim();

                      userService.updateUser(loggedUser).then((result) {
                        if (result) {
                          userService.setLoggedUser(loggedUser).then((result2) {
                            if (result2) {
                              if (arg == 1) {
                                if (loggedUser.preferredCategories == null || loggedUser.preferredCategories!.isEmpty) {
                                  Navigator.pushNamedAndRemoveUntil(context, categoryPreferencesPageRoute, (route) => false, arguments: 0);
                                } else {
                                  ref.watch(loggedUserProvider.notifier).state = loggedUser;
                                  Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
                                }
                              } else {
                                ref.read(loggedUserProvider.notifier).state = loggedUser;
                                Navigator.pop(context);
                              }
                            }
                          });
                        }
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
                        url: loggedUser.profilePhotoURL ?? ImageAssetKeys.defaultProfilePhotoUrl,
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
              getFormField(
                getTranslated(context, AppKeys.firstName),
                _firstNameTextEditingController,
                20,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (firstNameText) {
                  if (firstNameText!.trim().isEmpty) {
                    AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterFirstName),
                        backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                    return "";
                  }
                  return null;
                },
              ),
              getFormField(
                getTranslated(context, AppKeys.lastName),
                _lastNameTextEditingController,
                20,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
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
              getFormField(
                getTranslated(context, AppKeys.description),
                _descriptionTextEditingController,
                100,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              Column(
                children: [
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
                ],
              ),
              Column(
                children: [
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: DropdownButton<int>(
                        value: selectedGender,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        autofocus: true,
                        items: <DropdownMenuItem<int>>[
                          getDropdownItem(getTranslated(context, AppKeys.male), 0),
                          getDropdownItem(getTranslated(context, AppKeys.female), 1),
                          getDropdownItem(getTranslated(context, AppKeys.iDoNotWantToSpecify), 2),
                        ],
                        selectedItemBuilder: (context) {
                          return [
                            getDropdownSelectedItem(getTranslated(context, AppKeys.male)),
                            getDropdownSelectedItem(getTranslated(context, AppKeys.female)),
                            getDropdownSelectedItem(getTranslated(context, AppKeys.iDoNotWantToSpecify)),
                          ];
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
                              text: getTranslated(context, AppKeys.gender),
                              color: hintTextLightColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                textInputAction: TextInputAction.next,
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

  DropdownMenuItem<int> getDropdownItem(String label, int value) {
    return DropdownMenuItem<int>(
      value: value,
      child: TextComponent(
        text: label,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
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

  Widget getFormField(String labelText, TextEditingController textEditingController, int? maxCharacter,
      {TextCapitalization? textCapitalization, TextInputAction? textInputAction, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 3),
            child: TextComponent(
              text: labelText,
              headerType: HeaderType.h7,
              color: textPrimaryLightColor,
            ),
          ),
        ),
        TextFormFieldComponent(
          context: context,
          textEditingController: textEditingController,
          textCapitalization: textCapitalization ?? TextCapitalization.sentences,
          enabled: !isLoading,
          textInputAction: textInputAction ?? TextInputAction.done,
          hintText: labelText,
          keyboardType: keyboardType ?? TextInputType.text,
          maxCharacter: maxCharacter,
          validator: validator,
        ),
      ],
    );
  }

  bool _checkInformations() {
    if (_firstNameTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterFirstName), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (_lastNameTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterLastName), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (selectedDate == null || _dateOfBirthTextEditingController.text.trim().isEmpty) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.enterDateOfBirth), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else if (selectedGender == null) {
      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.selectGender), backgroundColor: warningDark, icon: CustomIconData.featherPointed);
      return false;
    } else {
      return true;
    }
  }
}
