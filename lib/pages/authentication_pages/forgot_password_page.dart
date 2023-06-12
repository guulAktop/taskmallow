import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String emailArg = "";

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.red, // StatusBar (durum çubuğu) rengi
      statusBarIconBrightness: Brightness.light, // StatusBar (durum çubuğu) ikon rengi
    ));
  }

  @override
  void didChangeDependencies() {
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
                              Navigator.pushNamed(context, verificationCodePageRoute);
                              if (_loginFormKey.currentState!.validate()) {}
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
          ),
        ]);
  }
}
