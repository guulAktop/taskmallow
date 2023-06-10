import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/pages/authentication_pages/login_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with WidgetsBindingObserver {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _passwordAgainTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
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
                  const Text(
                    "Lets start!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign up to manage your projects and more...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (emailText) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _passwordTextEditingController,
                    isPassword: true,
                    focusNode: _focusNode2,
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode3),
                    validator: (passwordText) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _passwordAgainTextEditingController,
                    isPassword: true,
                    focusNode: _focusNode3,
                    hintText: "Password (Again)",
                    keyboardType: TextInputType.visiblePassword,
                    validator: (passwordText) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ButtonComponent(
                    text: "Sign Up",
                    isWide: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () {
                            debugPrint(WidgetsBinding.instance.window.viewInsets.bottom.toString());
                            _login();
                          },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                                  child: const Text(
                                    "Sign In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
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
                                child: const Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white)),
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
