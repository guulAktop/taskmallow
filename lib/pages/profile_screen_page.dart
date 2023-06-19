import 'package:flutter/material.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> {
  bool isLoading = false;
  List<String> selectedSubtitles = ["artificial_intelligence", "mobile_applications", "data_analytics", "cloud_computing", "internet_of_things_iot"];
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Profile Screen",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: UIHelper.getDeviceWidth(context) / 4,
                  height: UIHelper.getDeviceWidth(context) / 4,
                  child: CircularPhotoComponent(
                    url: ImageAssetKeys.defaultProfilePhotoUrl,
                    hasBorder: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextComponent(
                        text: "First Last",
                        fontWeight: FontWeight.bold,
                        headerType: HeaderType.h4,
                        textAlign: TextAlign.start,
                      ),
                      const TextComponent(
                        text: "enescerrahoglu1@gmail.com",
                        headerType: HeaderType.h8,
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        children: [
                          InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: IconComponent(
                                iconData: CustomIconData.linkedin,
                                color: Color(0xFF0A66C2),
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: IconComponent(
                                iconData: CustomIconData.twitter,
                                color: Color(0xFF1DA1F2),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const TextComponent(
              text: "Computer Engineer",
              headerType: HeaderType.h6,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Projects Involved: ",
                    style: TextStyle(
                      color: textPrimaryLightColor,
                      fontSize: 18,
                      fontFamily: "Poppins",
                    ),
                  ),
                  TextSpan(
                    text: "3",
                    style: TextStyle(
                      color: textPrimaryLightColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
            RichText(
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
                    text: "27",
                    style: TextStyle(
                      color: textPrimaryLightColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: secondaryColor, thickness: 1),
            ),
            const TextComponent(
              text: "Preferences Categories",
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: itemBackgroundLightColor,
              ),
              padding: const EdgeInsets.all(10),
              child: selectedSubtitles.isNotEmpty
                  ? Wrap(spacing: 10, runSpacing: 10, children: selectedSubtitles.map((item) => buildItemContainer(item)).toList())
                  : const IconComponent(
                      iconData: CustomIconData.listCheck,
                      color: primaryColor,
                      size: 35,
                    ),
            ),
            const SizedBox(height: 20),
            const TextComponent(
              text: "Projects",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
            const SizedBox(height: 10),
            getProjectContainer(),
            getProjectContainer(),
            getProjectContainer(),
          ],
        )
      ],
    );
  }

  Widget getProjectContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pushNamed(context, updateProjectPageRoute);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextComponent(
              text: "Project Name",
              headerType: HeaderType.h4,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            const TextComponent(
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              textAlign: TextAlign.start,
              headerType: HeaderType.h6,
            ),
            const SizedBox(height: 10),
            const TextComponent(
              text:
                  "33% Complete", //"${(tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length * 100).toStringAsFixed(0)}% Complete",
              textAlign: TextAlign.start,
              overflow: TextOverflow.fade,
              softWrap: true,
              headerType: HeaderType.h7,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: LinearProgressIndicator(
                minHeight: 20,
                value: (0.33).toDouble(),
              ),
            ),
            const SizedBox(height: 10),
            const TextComponent(
              text: "created by email@gmail.com",
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.end,
              overflow: TextOverflow.fade,
              softWrap: true,
              headerType: HeaderType.h7,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemContainer(String item) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: textPrimaryDarkColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: MarqueeWidget(
              child: TextComponent(
                text: getTranslated(context, item),
                headerType: HeaderType.h7,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
