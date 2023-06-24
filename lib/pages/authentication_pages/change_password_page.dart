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
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = ref.read(verificationUserProvider);
    _emailTextEditingController.text = userModel!.email;
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return BaseScaffoldWidget(
      appBarBackgroundColor: Colors.transparent,
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: getTranslated(context, AppKeys.changePassword),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft, color: Colors.black),
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
                  getTranslated(context, AppKeys.changePasswordContent),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: primaryColor, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _emailTextEditingController,
                  enabled: false,
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
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _passwordTextEditingController,
                  focusNode: _focusNode1,
                  onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                  textInputAction: TextInputAction.next,
                  isPassword: true,
                  hintText: getTranslated(context, AppKeys.password),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (passwordText) {
                    bool passwordValid = AppConstants.passwordRegex.hasMatch(passwordText!);
                    if (passwordText.length < 8 || !passwordValid) {
                      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.passwordVerificationMessage),
                          backgroundColor: dangerDark, icon: CustomIconData.lockKeyhole);
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: _confirmPasswordTextEditingController,
                  focusNode: _focusNode2,
                  isPassword: true,
                  hintText: getTranslated(context, AppKeys.passwordAgain),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (passwordText) {
                    if (_confirmPasswordTextEditingController.text != _passwordTextEditingController.text) {
                      if ((_passwordTextEditingController.text.length >= 8) && AppConstants.passwordRegex.hasMatch(_passwordTextEditingController.text)) {
                        AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.passwordCheckMessage),
                            backgroundColor: dangerDark, icon: CustomIconData.lockKeyhole);
                      }
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ButtonComponent(
                  text: getTranslated(context, AppKeys.update),
                  isWide: true,
                  isLoading: _isLoading,
                  onPressed: _isLoading
                      ? null
                      : () {
                          _update(userRepository);
                        },
                ),
                const SizedBox(height: 20),
                const Spacer(),
              ],
            ),
          ),
        )
      ],
    );
  }

  _update(UserRepository userRepository) {
    if (_loginFormKey.currentState!.validate()) {
      userModel!.password = _passwordTextEditingController.text;
      setState(() {
        _isLoading = true;
      });
      userRepository.updatePassword(userModel!).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (userRepository.isSucceeded) {
          AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.passwordUpdated), backgroundColor: success, icon: CustomIconData.circleCheck);
          Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
        } else {
          AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.somethingWentWrong), backgroundColor: danger, icon: CustomIconData.circleXmark);
          Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
        }
      });
    } else {
      debugPrint("false");
    }
  }
}
