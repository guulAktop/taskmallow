import 'package:flutter/material.dart';
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
import 'package:taskmallow/pages/photo_view_page.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenPage extends ConsumerStatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  ConsumerState<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends ConsumerState<ProfileScreenPage> with TickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    ref.read(userProvider).isLoading = true;
    Future.delayed(Duration.zero, () async {
      UserModel userArg = ModalRoute.of(context)!.settings.arguments as UserModel;
      await ref.read(userProvider).getSelectedUserByEmail(userArg.email).whenComplete(() async {
        await ref.read(userProvider).getSelectedUserProjects().whenComplete(() {
          ref.read(userProvider).isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return userRepository.isLoading
        ? const BaseScaffoldWidget(
            widgetList: [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        : SliverScaffoldWidget(
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
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: UIHelper.getDeviceWidth(context) / 5,
                            height: UIHelper.getDeviceWidth(context) / 5,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        PhotoViewPage(url: userRepository.selectedUserModel!.profilePhotoURL),
                                    transitionDuration: const Duration(seconds: 0),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: userRepository.selectedUserModel!.profilePhotoURL,
                                child: CircularPhotoComponent(
                                  url: userRepository.selectedUserModel!.profilePhotoURL,
                                  hasBorder: false,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MarqueeWidget(
                                  child: TextComponent(
                                    text: "${userRepository.selectedUserModel?.firstName} ${userRepository.selectedUserModel?.lastName}",
                                    fontWeight: FontWeight.bold,
                                    headerType: HeaderType.h3,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MarqueeWidget(
                                  child: TextComponent(
                                    text: userRepository.selectedUserModel!.email,
                                    headerType: HeaderType.h7,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: userRepository.selectedUserModel!.description.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10),
                            TextComponent(
                              text: userRepository.selectedUserModel!.description,
                              headerType: HeaderType.h6,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          userRepository.selectedUserModel!.linkedinProfileURL.isEmpty
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
                                    if (await canLaunchUrl(Uri.parse("https://www.linkedin.com/in/${userRepository.selectedUserModel!.linkedinProfileURL}"))) {
                                      await launchUrl(Uri.parse("https://www.linkedin.com/in/${userRepository.selectedUserModel!.linkedinProfileURL}"),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                ),
                          userRepository.selectedUserModel!.twitterProfileURL.isEmpty
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
                                    if (await canLaunchUrl(Uri.parse("https://twitter.com/${userRepository.selectedUserModel!.twitterProfileURL}"))) {
                                      await launchUrl(Uri.parse("https://twitter.com/${userRepository.selectedUserModel!.twitterProfileURL}"),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
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
                        child: userRepository.selectedUserModel!.preferredCategories.isNotEmpty
                            ? Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: userRepository.selectedUserModel!.preferredCategories.map((item) => buildItemContainer(item)).toList())
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
                    text: "${getTranslated(context, AppKeys.projects)} (${userRepository.selectedUserProjects.length})",
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
                            text: userRepository.selectedUserProjects
                                .expand((project) => project.tasks)
                                .where((task) =>
                                    !task.isDeleted && task.situation == TaskSituation.done && task.assignedUserMail == userRepository.selectedUserModel!.email)
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
                        projectModel: userRepository.selectedUserProjects[index],
                        onTap: () {
                          if (userRepository.selectedUserProjects[index].collaborators
                              .map((collaborator) => collaborator.email)
                              .toList()
                              .contains(userRepository.userModel!.email)) {
                            Navigator.pushNamed(context, projectDetailPageRoute, arguments: userRepository.selectedUserProjects[index]);
                          } else {
                            Navigator.pushNamed(context, projectScreenPageRoute, arguments: userRepository.selectedUserProjects[index]);
                          }
                        },
                      );
                    },
                    childCount: userRepository.selectedUserProjects.length,
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
