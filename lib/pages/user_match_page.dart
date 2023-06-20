import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class UserMatchPage extends StatefulWidget {
  const UserMatchPage({super.key});

  @override
  State<UserMatchPage> createState() => _UserMatchPageState();
}

class _UserMatchPageState extends State<UserMatchPage> {
  bool isLoading = false;

  List<UserModel> invitedUsers = [];

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.yourMatches),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        TextComponent(
          text: getTranslated(context, AppKeys.hereAreTheCollaborators),
          textAlign: TextAlign.center,
        ),
        TextComponent(
          text: getTranslated(context, AppKeys.takeALook),
          color: matchColor,
          fontWeight: FontWeight.bold,
          headerType: HeaderType.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Column(
          children: users.map((user) => getUserRow(user)).toList(),
        ),
      ],
    );
  }

  Widget getUserRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: matchItemBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pushNamed(context, profilePageRoute);
        },
        child: Row(
          children: [
            SizedBox(
              width: UIHelper.getDeviceWidth(context) / 7,
              height: UIHelper.getDeviceWidth(context) / 7,
              child: CircularPhotoComponent(
                url: user.profilePhotoURL,
                hasBorder: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                    child: TextComponent(
                      text: "${user.firstName} ${user.lastName}",
                      fontWeight: FontWeight.bold,
                      headerType: HeaderType.h4,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  MarqueeWidget(
                    child: TextComponent(
                      text: user.email,
                      headerType: HeaderType.h7,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  tooltip: !invitedUsers.contains(user) ? getTranslated(context, AppKeys.invite) : getTranslated(context, AppKeys.removeInvite),
                  onPressed: () {
                    if (!invitedUsers.contains(user)) {
                      setState(() {
                        invitedUsers.add(user);
                      });
                    } else {
                      setState(() {
                        invitedUsers.remove(user);
                      });
                    }
                  },
                  icon: IconComponent(
                    iconData: !invitedUsers.contains(user) ? CustomIconData.paperPlane : CustomIconData.circleXmark,
                    color: !invitedUsers.contains(user) ? matchColor : dangerDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
