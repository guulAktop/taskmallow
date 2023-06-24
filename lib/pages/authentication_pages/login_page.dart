import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/pages/authentication_pages/register_page.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    SharedPreferencesHelper.getString("loggedUser").then((value) {
      if (value != null) {
        ref.read(userProvider).userModel = UserModel.fromJson(jsonDecode(value.toString()));
        Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
      } else {
        debugPrint("null sp user");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : () async => true,
      toolbarHeight: 0,
      widgetList: [
        Expanded(
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  getTranslated(context, AppKeys.welcome),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getTranslated(context, AppKeys.gladToSeeYou),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Spacer(),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _emailTextEditingController,
                  focusNode: _focusNode1,
                  onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                  textInputAction: TextInputAction.next,
                  hintText: getTranslated(context, AppKeys.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (emailText) {
                    bool emailValid = AppConstants.emailRegex.hasMatch(emailText!.trim().toLowerCase());
                    if (emailText.isEmpty || !emailValid) {
                      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.emailVerificationMessage),
                          backgroundColor: warningDark, icon: CustomIconData.envelope);
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _passwordTextEditingController,
                  isPassword: true,
                  focusNode: _focusNode2,
                  hintText: getTranslated(context, AppKeys.password),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (passwordText) {
                    bool passwordValid = AppConstants.passwordRegex.hasMatch(passwordText!);
                    if (passwordText.length < 8 || !passwordValid) {
                      if (AppConstants.emailRegex.hasMatch(_emailTextEditingController.text.trim().toLowerCase())) {
                        AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.checkYourInformation),
                            backgroundColor: warningDark, icon: CustomIconData.lockKeyhole, duration: 3);
                      }
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.black12)),
                    onPressed: () {
                      Navigator.pushNamed(context, forgotPasswordPageRoute, arguments: _emailTextEditingController.text.trim().toLowerCase());
                    },
                    child: Text(
                      getTranslated(context, AppKeys.forgotPassword),
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ButtonComponent(
                  text: getTranslated(context, AppKeys.signIn),
                  isWide: true,
                  isLoading: _isLoading,
                  onPressed: _isLoading
                      ? null
                      : () {
                          _login(userRepository);
                        },
                ),
                const SizedBox(height: 20),
                const Spacer(),
                Visibility(
                  visible: !isKeyboardVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: itemBackgroundLightColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  getTranslated(context, AppKeys.signIn),
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => const RegisterPage(),
                                      transitionDuration: Duration.zero,
                                    ),
                                    (route) => false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    getTranslated(context, AppKeys.signUp),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _login(UserRepository userRepository) {
    if (_loginFormKey.currentState!.validate()) {
      debugPrint("true");
      setState(() {
        _isLoading = true;
      });
      UserModel model = UserModel(
          email: _emailTextEditingController.text.trim().toLowerCase(),
          password: _passwordTextEditingController.text,
          firstName: "",
          lastName: "",
          description: "",
          linkedinProfileURL: "",
          twitterProfileURL: "");
      userRepository.hasProfile(model.email).then((value) {
        if (value) {
          ref.read(userProvider).login(model).then(
            (value) {
              if (userRepository.userModel != null) {
                ref.read(userProvider).userModel = model;

                ref.read(userProvider).setLoggedUser().then(
                  (value) {
                    if (ref.read(userProvider).isSucceeded) {
                      Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
                    }
                  },
                );
              } else {
                AppFunctions().showSnackbar(
                  context,
                  getTranslated(context, AppKeys.checkYourInformation),
                  icon: CustomIconData.userCheck,
                  backgroundColor: warningDark,
                );
                setState(
                  () {
                    _isLoading = false;
                  },
                );
              }
            },
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.nonExistingUser), icon: CustomIconData.userSlash, backgroundColor: dangerDark);
          }
        }
      });
    } else {
      debugPrint("false");
    }
  }
}
