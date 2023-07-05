import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  bool isLoading = false;

  String greeting() {
    int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return getTranslated(context, AppKeys.goodMorning);
    } else if (hour >= 12 && hour < 18) {
      return getTranslated(context, AppKeys.goodAfternoon);
    } else if (hour >= 18 && hour < 22) {
      return getTranslated(context, AppKeys.goodEvening);
    } else if (hour >= 22) {
      return getTranslated(context, AppKeys.goodNight);
    } else {
      return getTranslated(context, AppKeys.goodNight);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    ProjectRepository projectRepository = ref.watch(projectProvider);
    return SliverScaffoldWidget(
      centerTitle: false,
      leadingWidth: 0,
      title: "${greeting()} ${userRepository.userModel!.firstName}",
      actionList: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, searchPageRoute);
          },
          icon: const Padding(
            padding: EdgeInsets.all(3),
            child: IconComponent(
              iconData: CustomIconData.magnifyingGlass,
              size: 25,
            ),
          ),
          splashRadius: AppConstants.iconSplashRadius,
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, invitationsPageRoute);
          },
          icon: Stack(
            alignment: Alignment.topRight,
            children: [
              const Padding(
                padding: EdgeInsets.all(3),
                child: IconComponent(
                  iconData: CustomIconData.bell,
                  size: 25,
                ),
              ),
              userRepository.incomingInvitations.isEmpty
                  ? const SizedBox()
                  : Container(
                      decoration: const BoxDecoration(color: danger, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextComponent(
                            maxLines: 1,
                            text: userRepository.incomingInvitations.length <= 9 ? userRepository.incomingInvitations.length.toString() : "9",
                            headerType: HeaderType.h8,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          splashRadius: AppConstants.iconSplashRadius,
        ),
      ],
      widgetList: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getMatchingContainer(),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: TextComponent(
              text: getTranslated(context, AppKeys.latestProjects),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
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
                  projectModel: projectRepository.latestProjects[index],
                  onTap: () {
                    ref.read(projectProvider).projectModel = projectRepository.latestProjects[index];
                    if (projectRepository.latestProjects[index].collaborators
                        .map((collaborator) => collaborator.email)
                        .toList()
                        .contains(userRepository.userModel!.email)) {
                      Navigator.pushNamed(context, projectDetailPageRoute, arguments: projectRepository.latestProjects[index]);
                    } else {
                      Navigator.pushNamed(context, projectScreenPageRoute, arguments: projectRepository.latestProjects[index]);
                    }
                  },
                );
              },
              childCount: projectRepository.latestProjects.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget getMatchingContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: matchColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconComponent(
                iconData: CustomIconData.wandMagicSparkles,
                color: textPrimaryDarkColor,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextComponent(
                  text: getTranslated(context, AppKeys.projectMatchContext),
                  textAlign: TextAlign.start,
                  color: textPrimaryDarkColor,
                  headerType: HeaderType.h6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ButtonComponent(
            text: getTranslated(context, AppKeys.startMatch),
            isOutLined: true,
            isWide: true,
            textPadding: 6,
            color: textPrimaryDarkColor,
            onPressed: () {
              Navigator.pushNamed(context, projectMatchPageRoute);
            },
          ),
        ],
      ),
    );
  }
}
