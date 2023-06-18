import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../components/text_component.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  File? pickedImage;
  double progressValue = 0.7;
  int  projectsInvolvedCounter = 3;
  int completedTaskCounter = 27;

  static const projectCreater = "taskmallow";
  final List<String> _subcategories = [
    'subcategory1',
    'subcategory2',
    'subcategory3',
    'subcategory4',
    'subcategory5'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Profile",
      actionList: [
        IconButton(
            splashRadius: AppConstants.iconSplashRadius,
            icon: const IconComponent(iconData: CustomIconData.gear),
            onPressed: () => Navigator.pushNamed(context, settingsPageRoute)),
        IconButton(
            splashRadius: AppConstants.iconSplashRadius,
            icon: const IconComponent(iconData: CustomIconData.pencil),
            onPressed: () =>
                Navigator.pushNamed(context, editProfilePageRoute)),
      ],
      widgetList: [
        buildProfileWidget(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextComponent(
                text: 'Computeer Engineer', headerType: HeaderType.h6),
            const SizedBox(height: 10),
            Row(
              children: [
                const TextComponent(
                    text: 'Projects Involved: ', headerType: HeaderType.h4),
                TextComponent(
                    text: projectsInvolvedCounter.toString(),
                    headerType: HeaderType.h4,
                    fontWeight: FontWeight.bold),
              ],
            ),
            Row(
              children: [
                const TextComponent(
                    text: 'Completed Task: ', headerType: HeaderType.h4),
                TextComponent(
                    text: completedTaskCounter.toString(),
                    headerType: HeaderType.h4,
                    fontWeight: FontWeight.bold),
              ],
            ),
            const Divider(color: secondaryColor),
            const TextComponent(
                text: 'Preferences Categories', fontWeight: FontWeight.bold),
            const SizedBox(height: 3),
            categoryRow(
              subcategories: _subcategories,
            ),
            const SizedBox(height: 20),
            const TextComponent(
                text: 'Projects Involved', fontWeight: FontWeight.bold),
            const SizedBox(height: 3),
            projectWidget(),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    pickedImage = null;
  }

  Widget projectWidget() {
    return Column(
      children: const [
        ProjectContainer(
          title: 'Taskmallow',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.7,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
      ],
    );
  }

  Widget buildProfileWidget() {
    return Row(
      children: [
        // Sol
        Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
            child: SizedBox(
              height: UIHelper.isDevicePortrait(context)
                  ? UIHelper.getDeviceWidth(context) / 4.5
                  : UIHelper.getDeviceHeight(context) / 4,
              width: UIHelper.isDevicePortrait(context)
                  ? UIHelper.getDeviceWidth(context) / 4.5
                  : UIHelper.getDeviceHeight(context) / 4,
              child: CircularPhotoComponent(
                url: ImageAssetKeys.defaultProfilePhotoUrl,
              ),
            )),
        // Sağ
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextComponent(
                text: 'Şevval Özdamar',
                headerType: HeaderType.h4,
                fontWeight: FontWeight.bold),
            const TextComponent(
                text: 'sevvalozdamar@gmail.com', headerType: HeaderType.h6),
            Row(
              children: [
                IconButton(
                    splashRadius: AppConstants.iconSplashRadius,
                    icon: const IconComponent(
                        iconData: CustomIconData.addressCard),
                    onPressed: () {}),
                IconButton(
                    splashRadius: AppConstants.iconSplashRadius,
                    icon: const IconComponent(
                        iconData: CustomIconData.addressCard),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// PROJECT CONTAINER
class ProjectContainer extends StatelessWidget {
  final String title;
  final String description;
  final String createdBy;
  final double progressValue;

  const ProjectContainer({
    super.key,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: itemBackgroundLightColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComponent(
                text: title,
                headerType: HeaderType.h5,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              TextComponent(
                textAlign: TextAlign.start,
                text: description,
                headerType: HeaderType.h6,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const TextComponent(
                    text: 'created by ',
                    headerType: HeaderType.h7,
                  ),
                  TextComponent(
                    text: createdBy,
                    headerType: HeaderType.h7,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 7,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextComponent(
                      text: '%${(progressValue * 100).toInt()}',
                      headerType: HeaderType.h6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CATEGORY ROW

Widget categoryRow({required List<String> subcategories}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Wrap(
        spacing: 5.0,
        children: subcategories.map((subcategory) {
          return Chip(
            label: Text(subcategory),
            backgroundColor: shimmerLightHighlightColor,
          );
        }).toList(),
      ),
    ),
  );
}
