import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/project_row_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  final TextEditingController _searchTextEditingController = TextEditingController();

  List<UserModel> filteredUsers = [];
  List<ProjectModel> filteredProjects = [];

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.searchUserOrProject),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      widgetList: [
        TextFormFieldComponent(
          context: context,
          textEditingController: _searchTextEditingController,
          iconData: CustomIconData.magnifyingGlass,
          hintText: getTranslated(context, AppKeys.search),
          onChanged: (text) {
            setState(
              () {
                if (text.isEmpty) {
                  filteredUsers.clear();
                } else {
                  filteredUsers = users
                      .where((user) =>
                          user.firstName.toLowerCase().contains(text.toLowerCase()) ||
                          user.lastName.toLowerCase().contains(text.toLowerCase()) ||
                          user.email.toLowerCase().contains(text.toLowerCase()) ||
                          ("${user.firstName} ${user.lastName}").toLowerCase().contains(text.toLowerCase()))
                      .toList();

                  filteredProjects = projects
                      .where((project) =>
                          project.name.toLowerCase().contains(text.toLowerCase()) ||
                          project.description.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.email.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.firstName.toLowerCase().contains(text.toLowerCase()) ||
                          project.userWhoCreated.lastName.toLowerCase().contains(text.toLowerCase()) ||
                          ("${project.userWhoCreated.firstName} ${project.userWhoCreated.lastName}").toLowerCase().contains(text.toLowerCase()))
                      .toList();
                }
              },
            );
          },
        ),
        Visibility(
          visible: _searchTextEditingController.text.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextComponent(
                text: filteredUsers.isNotEmpty ? getTranslated(context, AppKeys.users) : getTranslated(context, AppKeys.userNotFound),
                color: filteredUsers.isNotEmpty ? textPrimaryLightColor : danger,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Column(
                children: filteredUsers.map((user) => getUserRow(user)).toList(),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _searchTextEditingController.text.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextComponent(
                text: filteredProjects.isNotEmpty ? getTranslated(context, AppKeys.projects) : getTranslated(context, AppKeys.projectNotFound),
                color: filteredProjects.isNotEmpty ? textPrimaryLightColor : danger,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Column(
                children: filteredProjects
                    .map(
                      (project) => ProjectRowItem(
                        project: project,
                        onTap: () {
                          Navigator.pushNamed(context, projectScreenPageRoute, arguments: project);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
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
          Navigator.pushNamed(context, profileScreenPageRoute);
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
          ],
        ),
      ),
    );
  }
}
