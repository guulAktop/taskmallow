import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

import '../../constants/string_constants.dart';
import '../../localization/app_localization.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();
  final TextEditingController _textEditingController4 = TextEditingController();
  final TextEditingController _textEditingController5 = TextEditingController();
  final TextEditingController _textEditingController6 = TextEditingController();
  bool _isLoading = false;
  late int seconds;
  String enteredCode = "";

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  int verificationType = 0;

  late Timer timer;

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
      title: getTranslated(context, AppKeys.verificationCode),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft, color: Colors.black),
        onPressed: () => _isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        const Spacer(),
        Text(
          getTranslated(context, AppKeys.enterThe6Digit),
          textAlign: TextAlign.center,
          style: const TextStyle(color: primaryColor, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Form(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getDigitField(1, _textEditingController1, _focusNode1),
              getDigitField(2, _textEditingController2, _focusNode2),
              getDigitField(3, _textEditingController3, _focusNode3),
              getDigitField(4, _textEditingController4, _focusNode4),
              getDigitField(5, _textEditingController5, _focusNode5),
              getDigitField(6, _textEditingController6, _focusNode6),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconComponent(
                    iconData: CustomIconData.circleInfo,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    getTranslated(context, AppKeys.checkSpamBox),
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ButtonComponent(
          isWide: true,
          text: getTranslated(context, AppKeys.verify),
          isLoading: _isLoading,
          onPressed: () {
            Navigator.pushNamed(context, changePasswordPageRoute);
            _verify();
          },
        ),
        const Spacer(),
      ],
    );
  }

  _verify() {
    String digit1 = _textEditingController1.text;
    String digit2 = _textEditingController2.text;
    String digit3 = _textEditingController3.text;
    String digit4 = _textEditingController4.text;
    String digit5 = _textEditingController5.text;
    String digit6 = _textEditingController6.text;
    enteredCode = digit1 + digit2 + digit3 + digit4 + digit5 + digit6;
    debugPrint("code: $enteredCode");
  }

  getDigitField(int index, TextEditingController textEditingController, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: SizedBox(
        width: UIHelper.getDeviceWidth(context) / 9,
        child: TextFormField(
          toolbarOptions: const ToolbarOptions(copy: false, cut: false, paste: false, selectAll: false),
          enableInteractiveSelection: false,
          showCursor: false,
          focusNode: focusNode,
          controller: textEditingController,
          onTap: () {
            textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);
          },
          onChanged: (value) {
            if (textEditingController.text.isNotEmpty) {
              if (index == 1) {
                FocusScope.of(context).requestFocus(_focusNode2);
              } else if (index == 2) {
                FocusScope.of(context).requestFocus(_focusNode3);
              } else if (index == 3) {
                FocusScope.of(context).requestFocus(_focusNode4);
              } else if (index == 4) {
                FocusScope.of(context).requestFocus(_focusNode5);
              } else if (index == 5) {
                FocusScope.of(context).requestFocus(_focusNode6);
              } else if (index == 6) {
                FocusScope.of(context).unfocus();
              }
            }
            if (textEditingController.text.isEmpty) {
              if (index == 6) {
                FocusScope.of(context).requestFocus(_focusNode5);
              } else if (index == 5) {
                FocusScope.of(context).requestFocus(_focusNode4);
              } else if (index == 4) {
                FocusScope.of(context).requestFocus(_focusNode3);
              } else if (index == 3) {
                FocusScope.of(context).requestFocus(_focusNode2);
              } else if (index == 2) {
                FocusScope.of(context).requestFocus(_focusNode1);
              }
            }
            setState(() {
              if (textEditingController.text.length > 1) {
                textEditingController.text = value.substring(value.length - 1);
              }
            });
          },
          textAlign: TextAlign.center,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryColor, width: 2)),
            filled: true,
            fillColor: containerColor,
            contentPadding: const EdgeInsets.all(0),
          ),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(signed: true),
        ),
      ),
    );
  }

  showAysForCancelDialog() {
    return true;
  }
}
