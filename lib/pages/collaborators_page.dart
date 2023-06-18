import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class CollaboratorsPage extends StatefulWidget {
  const CollaboratorsPage({super.key});

  @override
  State<CollaboratorsPage> createState() => _CollaboratorsPageState();
}

class _CollaboratorsPageState extends State<CollaboratorsPage> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
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

  List<UserModel> filteredInvated = [];
  @override
  void initState() {
    filteredInvated = users;
    super.initState();
  }

  void filteredUsers(String searchText) {
    setState(() {
      filteredInvated = users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}';
        return fullName.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  void onPresInvite(UserModel user) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return BaseScaffoldWidget(
      title: "Collaborators Page",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        const Align(
          alignment: Alignment.centerLeft,
          child: TextComponent(
            text: "Collaborators",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: users
                  .map((user) => InkWell(
                    onTap: () {
                      
                   showModalBottomSheet(context: context, builder: );
                    },
                    child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularPhotoComponent(
                                    url: user.profilePhotoURL, hasBorder: false),
                              ),
                              TextComponent(
                                text: user.firstName[0] + user.lastName[0],
                                headerType: HeaderType.h6,
                              )
                            ],
                          ),
                        ),
                  ))
                  .toList()),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: TextComponent(
            text: "Invited Users",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
         InvatedOrRemove(
          users: invitedUsers,
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: TextComponent(
            text: "Find Users",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
        TextFormFieldComponent(
          onChanged: (value) {
            if (filteredInvated.isEmpty) {
              return null;
            }
            filteredUsers(value);
          },
          context: context,
          textEditingController: _searchTextEditingController,
          hintText: "Search collaborators",
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        InvatedOrRemove(
          users: filteredInvated,
        ),
        Row(
          children: const [
            Expanded(
              child: Divider(thickness: 1.5),
            ),
            Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: TextComponent(
                  text: "or",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                )),
            Expanded(
              child: Divider(thickness: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ButtonComponent(
          text: "Start Matching",
          icon: CustomIconData.wandMagicSparkles,
          onPressed: () {},
          color: matchColor,
          isWide: true,
        ),
      ],
    );
  }
}

List<UserModel> invitedUsers = [];

class InvatedOrRemove extends StatefulWidget {
  List<UserModel> users = [];
  InvatedOrRemove({Key? key, required this.users}) : super(key: key);

  @override
  _InvatedOrRemoveState createState() => _InvatedOrRemoveState();
}

class _InvatedOrRemoveState extends State<InvatedOrRemove> {
  List<bool> _isVisibleList = [];

  @override
  void initState() {
    super.initState();
    _isVisibleList = List.generate(widget.users.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.users.length, (index) {
        final item = widget.users[index];
        return Column(
          children: [
            Visibility(
              visible:  index < _isVisibleList.length && _isVisibleList[index],
              child: Container(
                padding: const EdgeInsets.all(10),
                width: UIHelper.getDeviceWidth(context),
                decoration: BoxDecoration(
                  color: shimmerLightHighlightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularPhotoComponent(
                            url: item.profilePhotoURL,
                            hasBorder: false,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextComponent(
                              text: item.firstName + ' ' + item.lastName,
                              headerType: HeaderType.h6,
                              fontWeight: FontWeight.bold,
                            ),
                            TextComponent(
                              text: item.email,
                              headerType: HeaderType.h8,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: UIHelper.getDeviceWidth(context),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: secondaryColor,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isVisibleList[index] = false;
                            invitedUsers.add(widget.users[index]);
                            debugPrint(invitedUsers.toString());
                          });
                        },
                        child: const TextComponent(
                          text: "Invite",
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }
}
