import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/pages/authentication_pages/login_page.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/services/user_service.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../../constants/string_constants.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _passwordAgainTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  UserService userService = UserService();

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  getTranslated(context, AppKeys.letsStart),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getTranslated(context, AppKeys.signUpToManage),
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
                    bool emailValid = AppConstants.emailRegex.hasMatch(emailText!);
                    if (emailText.isEmpty || !emailValid) {
                      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.emailVerificationMessage),
                          backgroundColor: warningDark, icon: CustomIconData.envelope);
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _passwordTextEditingController,
                  isPassword: true,
                  focusNode: _focusNode2,
                  hintText: getTranslated(context, AppKeys.password),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode3),
                  validator: (passwordText) {
                    bool passwordValid = AppConstants.passwordRegex.hasMatch(passwordText!);
                    if (passwordText.length < 8 || !passwordValid) {
                      if (AppConstants.emailRegex.hasMatch(_emailTextEditingController.text)) {
                        AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.passwordVerificationMessage),
                            backgroundColor: warningDark, icon: CustomIconData.lockKeyhole, duration: 3);
                      }
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _passwordAgainTextEditingController,
                  isPassword: true,
                  focusNode: _focusNode3,
                  hintText: getTranslated(context, AppKeys.passwordAgain),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (passwordText) {
                    if (_passwordAgainTextEditingController.text != _passwordTextEditingController.text) {
                      if ((_passwordTextEditingController.text.length >= 8) && AppConstants.passwordRegex.hasMatch(_passwordTextEditingController.text)) {
                        AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.passwordCheckMessage),
                            backgroundColor: warningDark, icon: CustomIconData.lockKeyhole);
                      }
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ButtonComponent(
                  text: getTranslated(context, AppKeys.signUp),
                  isWide: true,
                  isLoading: _isLoading,
                  onPressed: _isLoading
                      ? null
                      : () {
                          _register();
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
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => const LoginPage(),
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
                                    getTranslated(context, AppKeys.signIn),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                  getTranslated(context, AppKeys.signUp),
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _register() {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      UserModel model = UserModel(email: _emailTextEditingController.text.trim().toLowerCase(), password: _passwordTextEditingController.text);
      userService.hasProfile(model.email).then(
        (value) async {
          if (value) {
            AppFunctions().showSnackbar(context, getTranslated(context, getTranslated(context, AppKeys.currentUser)),
                backgroundColor: warningDark, icon: CustomIconData.circleUser);
            setState(() {
              _isLoading = false;
            });
          } else {
            ref.watch(verificationCodeProvider.notifier).state = AppFunctions().generateCode();
            AppFunctions().sendVerificationCode(context, model.email, ref.watch(verificationCodeProvider).toString()).then((value) {
              AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.codeSent), icon: CustomIconData.paperPlane, backgroundColor: infoDark);
              setState(() {
                _isLoading = false;
              });
              ref.watch(verificationUserProvider.notifier).state = model;
              Navigator.pushNamed(context, verificationCodePageRoute, arguments: 0);
            });
          }
        },
      );
    } else {
      debugPrint("false");
    }
  }
}
