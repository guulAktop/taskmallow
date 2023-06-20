import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../components/icon_component.dart';
import '../constants/app_constants.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  bool isLoading = false;

  List<InvitationModel>? invitations = [];

  @override
  void initState() {
    super.initState();
    invitations = [
      InvitationModel(id: DateTime.now().microsecond.toString(), projectModel: projects[0], to: "gul.aktopp@gmail.com"),
      InvitationModel(id: DateTime.now().microsecond.toString(), projectModel: projects[2], to: "gul.aktopp@gmail.com"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.invitations),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: invitations!.map((invitation) => getInvitationRow(invitation)).toList(),
    );
  }

  Widget getInvitationRow(InvitationModel invitationModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${invitationModel.projectModel.userWhoCreated.firstName} ${invitationModel.projectModel.userWhoCreated.lastName}",
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint("${invitationModel.projectModel.userWhoCreated.firstName} ${invitationModel.projectModel.userWhoCreated.lastName}");
                    },
                ),
                TextSpan(
                  text: getTranslated(context, AppKeys.invitationMessagePart1),
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                ),
                TextSpan(
                  text: invitationModel.projectModel.name,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint(invitationModel.projectModel.name);
                    },
                ),
                TextSpan(
                  text: getTranslated(context, AppKeys.invitationMessagePart2),
                  style: const TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ButtonComponent(
                  text: getTranslated(context, AppKeys.accept),
                  textPadding: 8,
                  isOutLined: true,
                  color: success,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  child: ButtonComponent(
                    text: getTranslated(context, AppKeys.reject),
                    textPadding: 8,
                    isOutLined: true,
                    color: danger,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
