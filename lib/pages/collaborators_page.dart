import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class CollaboratorsPage extends StatefulWidget {
  const CollaboratorsPage({super.key});

  @override
  State<CollaboratorsPage> createState() => _CollaboratorsPageState();
}

class _CollaboratorsPageState extends State<CollaboratorsPage> {
  bool isLoading = false;

  List<UserModel> users = [
    UserModel(
        email: "enescerrahoglu1@gmail.com",
        firstName: "Enes",
        lastName: "Cerrahoğlu",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
    UserModel(
        email: "gul.aktopp@gmail.com",
        firstName: "Gülsüm",
        lastName: "Aktop",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fg%C3%BCl.jpg?alt=media&token=4d5b013c-30c5-4ce4-a5c7-01a3c7b0ac38"),
    UserModel(
        email: "ozdamarsevval.01@gmail.com",
        firstName: "Şevval",
        lastName: "Özdamar",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2F%C5%9Fevval.jpg?alt=media&token=bafb43ec-1dd3-4233-9619-9b1ed3e26189"),
    UserModel(
        email: "izzetjmy@gmail.com",
        firstName: "İzzet",
        lastName: "Jumayev",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fizzet.jpg?alt=media&token=4e7aef85-9d1d-4cfd-9e2e-58388b6bbe4e"),
    UserModel(
        email: "msalihgirgin@gmail.com",
        firstName: "Muhammed Salih",
        lastName: "Girgin",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fsalih.jpg?alt=media&token=7034fffb-51e0-4dac-9f00-498d9939be4a"),
  ];

  List<UserModel> invitedUsers = [
    UserModel(
        email: "gul.aktopp@gmail.com",
        firstName: "Gülsüm",
        lastName: "Aktop",
        profilePhotoURL:
            "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fg%C3%BCl.jpg?alt=media&token=4d5b013c-30c5-4ce4-a5c7-01a3c7b0ac38"),
  ];

  List<UserModel> filteredUsers = [];

  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Collaborators",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextComponent(
              text: "Collaborators",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              softWrap: true,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: users
                    .map(
                      (user) => InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BaseScaffoldWidget(
                                  hasAppBar: false,
                                  widgetList: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: itemBackgroundLightColor,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: UIHelper.getDeviceWidth(context) / 4,
                                                height: UIHelper.getDeviceWidth(context) / 4,
                                                child: CircularPhotoComponent(
                                                  url: user.profilePhotoURL,
                                                  hasBorder: false,
                                                ),
                                              ),
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
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: itemBackgroundLightColor,
                                          ),
                                          child: MarqueeWidget(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Date of Involvement: ",
                                                    style: TextStyle(
                                                      color: textPrimaryLightColor,
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: DateFormat("dd.MM.yyyy").format(DateTime.now()).toString(),
                                                    style: const TextStyle(
                                                      color: textPrimaryLightColor,
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: itemBackgroundLightColor,
                                          ),
                                          child: MarqueeWidget(
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Completed Tasks: ",
                                                    style: TextStyle(
                                                      color: textPrimaryLightColor,
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "4",
                                                    style: TextStyle(
                                                      color: textPrimaryLightColor,
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    ButtonComponent(
                                      text: "Delete Collaborator",
                                      color: dangerDark,
                                      isWide: true,
                                      onPressed: () {},
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularPhotoComponent(url: user.profilePhotoURL, hasBorder: false),
                              ),
                              TextComponent(
                                text: user.firstName[0] + user.lastName[0],
                                headerType: HeaderType.h6,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Visibility(
              visible: invitedUsers.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const TextComponent(
                    text: "Invited Users",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                  Column(
                    children: invitedUsers.map((user) => getUserRow(user)).toList(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const TextComponent(
                  text: "Find Users",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                TextFormFieldComponent(
                  context: context,
                  textEditingController: searchTextEditingController,
                  hintText: "Search users",
                  onChanged: (text) {
                    setState(() {
                      if (text.isEmpty) {
                        filteredUsers.clear();
                      } else {
                        filteredUsers = users
                            .where((user) =>
                                user.firstName.toLowerCase().contains(text.toLowerCase()) ||
                                user.lastName.toLowerCase().contains(text.toLowerCase()) ||
                                user.email.toLowerCase().contains(text.toLowerCase()))
                            .where((user) => !invitedUsers.contains(user))
                            .toList();
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                Column(
                  children: filteredUsers.map((user) => getUserRow(user)).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: secondaryColor, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextComponent(
                        text: "or",
                        color: secondaryColor,
                      ),
                    ),
                    Expanded(
                      child: Divider(color: secondaryColor, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ButtonComponent(
                  text: "Start Matching",
                  color: matchColor,
                  icon: CustomIconData.wandMagicSparkles,
                  isWide: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getUserRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
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
                  tooltip: !invitedUsers.contains(user) ? "Invite" : "Remove Invite",
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
                    setState(() {
                      if (searchTextEditingController.text.isEmpty) {
                        filteredUsers.clear();
                      } else {
                        filteredUsers = users
                            .where((user) =>
                                user.firstName.toLowerCase().contains(searchTextEditingController.text.toLowerCase()) ||
                                user.lastName.toLowerCase().contains(searchTextEditingController.text.toLowerCase()) ||
                                user.email.toLowerCase().contains(searchTextEditingController.text.toLowerCase()))
                            .where((user) => !invitedUsers.contains(user))
                            .toList();
                      }
                    });
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
