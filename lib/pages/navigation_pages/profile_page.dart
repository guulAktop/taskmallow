import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with TickerProviderStateMixin {
  bool isLoading = false;
  bool showPreview = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserModel? userArg = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return SliverScaffoldWidget(
      title: getTranslated(context, AppKeys.profile),
      leadingWidget: userArg == null
          ? null
          : IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
      actionList: [
        IconButton(
          icon: const IconComponent(
            iconData: CustomIconData.pen,
          ),
          splashRadius: AppConstants.iconSplashRadius,
          onPressed: () {
            Navigator.pushNamed(context, updateProfilePageRoute);
          },
        ),
        IconButton(
          icon: const IconComponent(
            iconData: CustomIconData.gear,
          ),
          splashRadius: AppConstants.iconSplashRadius,
          onPressed: () {
            Navigator.pushNamed(context, settingsPageRoute);
          },
        ),
      ],
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
                    GestureDetector(
                      onLongPress: () {
                        HapticFeedback.vibrate();
                        setState(() {
                          showPreview = true;
                        });
                      },
                      onLongPressEnd: (details) {
                        HapticFeedback.vibrate();
                        setState(() {
                          showPreview = false;
                        });
                      },
                      child: SizedBox(
                        width: UIHelper.getDeviceWidth(context) / 4,
                        height: UIHelper.getDeviceWidth(context) / 4,
                        child: CircularPhotoComponent(
                          url: userRepository.userModel?.profilePhotoURL,
                          hasBorder: false,
                        ),
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
                              text: "${userRepository.userModel?.firstName} ${userRepository.userModel?.lastName}",
                              fontWeight: FontWeight.bold,
                              headerType: HeaderType.h3,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MarqueeWidget(
                            child: TextComponent(
                              text: userRepository.userModel!.email,
                              headerType: HeaderType.h7,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                            children: [
                              userRepository.userModel!.linkedinProfileURL.isEmpty
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
                                      onTap: () async {
                                        if (await canLaunchUrl(Uri.parse("https://www.linkedin.com/in/${userRepository.userModel!.linkedinProfileURL}"))) {
                                          await launchUrl(Uri.parse("https://www.linkedin.com/in/${userRepository.userModel!.linkedinProfileURL}"),
                                              mode: LaunchMode.externalApplication);
                                        }
                                      },
                                    ),
                              userRepository.userModel!.twitterProfileURL.isEmpty
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
                                      onTap: () async {
                                        if (await canLaunchUrl(Uri.parse("https://twitter.com/${userRepository.userModel!.twitterProfileURL}"))) {
                                          await launchUrl(Uri.parse("https://twitter.com/${userRepository.userModel!.twitterProfileURL}"),
                                              mode: LaunchMode.externalApplication);
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: userRepository.userModel!.description.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      TextComponent(
                        text: userRepository.userModel!.description,
                        headerType: HeaderType.h6,
                        textAlign: TextAlign.start,
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
                  child: userRepository.userModel!.preferredCategories.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: userRepository.userModel!.preferredCategories.map((item) => buildItemContainer(item)).toList()
                            ..add(
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  child: Material(
                                    color: textPrimaryDarkColor,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, categoryPreferencesPageRoute);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        child: const IconComponent(
                                          iconData: CustomIconData.pen,
                                          color: textPrimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        )
                      : Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, categoryPreferencesPageRoute);
                            },
                            splashRadius: AppConstants.iconSplashRadius,
                            icon: const IconComponent(
                              iconData: CustomIconData.circlePlus,
                              iconWeight: CustomIconWeight.regular,
                              color: primaryColor,
                              size: 35,
                            ),
                          ),
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
              text: "${getTranslated(context, AppKeys.projects)} (${projectRepository.allRelatedProjects.length})",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: itemBackgroundLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: RichText(
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
                    TextSpan(
                      text: projectRepository.allRelatedProjects
                          .expand((project) => project.tasks)
                          .where((task) => !task.isDeleted && task.situation == TaskSituation.done && task.assignedUserMail == userRepository.userModel!.email)
                          .length
                          .toString(),
                      style: const TextStyle(
                        color: textPrimaryLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
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
                  projectModel: projectRepository.allRelatedProjects[index],
                  onTap: () {
                    Navigator.pushNamed(context, projectDetailPageRoute, arguments: projectRepository.allRelatedProjects[index]);
                  },
                );
              },
              childCount: projectRepository.allRelatedProjects.length,
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
