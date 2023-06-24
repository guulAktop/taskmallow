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
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> with TickerProviderStateMixin {
  bool isLoading = false;

  UserModel user = users[1];
  List<String> selectedSubtitles = ["artificial_intelligence", "mobile_applications", "data_analytics", "cloud_computing", "internet_of_things_iot"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffoldWidget(
      title: getTranslated(context, AppKeys.profile),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: UIHelper.getDeviceWidth(context) / 4,
                      height: UIHelper.getDeviceWidth(context) / 4,
                      child: CircularPhotoComponent(
                        url: user.profilePhotoURL,
                        hasBorder: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarqueeWidget(
                            child: TextComponent(
                              text: "${user.firstName} ${user.lastName}",
                              fontWeight: FontWeight.bold,
                              headerType: HeaderType.h4,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MarqueeWidget(
                            child: TextComponent(
                              text: user.email,
                              headerType: HeaderType.h7,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                            children: [
                              user.linkedinProfileURL.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
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
                              user.twitterProfileURL.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: user.description.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      TextComponent(
                        text: user.description,
                        headerType: HeaderType.h6,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: getTranslated(context, AppKeys.projectsInvolved),
                        style: const TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const TextSpan(
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
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: getTranslated(context, AppKeys.completedTasks),
                        style: const TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const TextSpan(
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
                TextComponent(
                  text: getTranslated(context, AppKeys.preferredCategories),
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
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: TextComponent(
              text: getTranslated(context, AppKeys.projects),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: UIHelper.getDeviceWidth(context) / 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ProjectGridItem(
                  projectModel: projects[index],
                  onTap: () {
                    Navigator.pushNamed(context, projectScreenPageRoute, arguments: projects[index]);
                  },
                );
              },
              childCount: projects.length,
            ),
          ),
        ),
      ],
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
