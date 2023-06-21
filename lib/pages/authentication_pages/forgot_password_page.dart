import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/services/user_service.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  UserService userService = UserService();
  bool _isLoading = false;
  String emailArg = "";

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    emailArg = ModalRoute.of(context)?.settings.arguments as String;
    _emailTextEditingController.text = emailArg;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
        popScopeFunction: _isLoading ? () async => false : () async => true,
        appBarBackgroundColor: Colors.transparent,
        title: getTranslated(context, AppKeys.forgotPassword),
        leadingWidget: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.chevronLeft),
          onPressed: () => _isLoading ? null : Navigator.pop(context),
        ),
        widgetList: [
          Expanded(
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    getTranslated(context, AppKeys.forgotPasswordContent),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _emailTextEditingController,
                    hintText: getTranslated(context, AppKeys.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (emailText) {
                      bool emailValid = AppConstants.emailRegex.hasMatch(emailText!);
                      if (emailText.isEmpty || !emailValid) {
                        AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.emailVerificationMessage),
                            backgroundColor: dangerDark, icon: CustomIconData.envelope);
                        return "";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonComponent(
                    text: getTranslated(context, AppKeys.sendCode),
                    isWide: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_loginFormKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              bool hasProfile = await userService.hasProfile(_emailTextEditingController.text);
                              debugPrint(_emailTextEditingController.text);
                              if (hasProfile) {
                                ref.watch(verificationCodeProvider.notifier).state = AppFunctions().generateCode();

                                if (mounted) {}
                                AppFunctions()
                                    .sendVerificationCode(
                                        context, _emailTextEditingController.text.replaceAll(" ", ""), ref.watch(verificationCodeProvider).toString())
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.codeSent),
                                      icon: CustomIconData.paperPlane, backgroundColor: infoDark);
                                  ref.watch(verificationUserProvider.notifier).state = UserModel(email: _emailTextEditingController.text, password: "");
                                  Navigator.pushNamed(context, verificationCodePageRoute, arguments: 1);
                                });
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });

                                if (mounted) {
                                  AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.nonExistingUser),
                                      icon: CustomIconData.userSlash, backgroundColor: dangerDark);
                                }
                              }
                            }
                          },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ]);
  }
}
