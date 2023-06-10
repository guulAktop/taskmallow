import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      appBarBackgroundColor: Colors.transparent,
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: "Change Password",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft, color: Colors.black),
        onPressed: () => _isLoading ? null : Navigator.pop(context),
      ),
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
                    "Please enter the password you want to\nupdate correctly in the fields below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _passwordTextEditingController,
                    focusNode: _focusNode1,
                    onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                    textInputAction: TextInputAction.next,
                    isPassword: true,
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    validator: (passwordText) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _confirmPasswordTextEditingController,
                    focusNode: _focusNode2,
                    isPassword: true,
                    hintText: "Password (Again)",
                    keyboardType: TextInputType.visiblePassword,
                    validator: (passwordText) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ButtonComponent(
                    text: "Update",
                    isWide: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () {
                            _update();
                          },
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _update() {
    Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
  }
}
