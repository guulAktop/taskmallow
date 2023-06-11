import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/authentication_pages/register_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {
      final keyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom != 0.0;
      isKeyboardVisible = keyboardVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : () async => true,
      toolbarHeight: 0,
      widgetList: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                      color: midTitleColor,
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.black12)),
                      onPressed: () {
                        Navigator.pushNamed(context, forgotPasswordPageRoute);
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
                            debugPrint(WidgetsBinding.instance.window.viewInsets.bottom.toString());
                            _login();
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
                          color: Colors.white,
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
        ),
      ],
    );
  }

  void _login() {}
}
