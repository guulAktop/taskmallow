import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class NoUserPage extends ConsumerStatefulWidget {
  const NoUserPage({super.key});

  @override
  ConsumerState<NoUserPage> createState() => _NoUserPageState();
}

class _NoUserPageState extends ConsumerState<NoUserPage> {
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
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    String greetingMessage = greeting();
    return RefreshIndicator(
      onRefresh: () async {
        greetingMessage = greeting();
        await projectRepository.getLatestProjects();
      },
      child: SliverScaffoldWidget(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        centerTitle: false,
        leadingWidth: 0,
        title: greetingMessage.replaceAll(",", ""),
        actionList: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, loginPageRoute);
            },
            icon: const Padding(
              padding: EdgeInsets.all(3),
              child: IconComponent(
                iconData: CustomIconData.arrowRightToBracket,
              ),
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
            sliver: projectRepository.latestProjects.isNotEmpty
                ? SliverGrid(
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
                            AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.registerNowForThisProject),
                                icon: CustomIconData.arrowRightToBracket, backgroundColor: primaryColor);
                          },
                        );
                      },
                      childCount: projectRepository.latestProjects.length,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget getMatchingContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconComponent(
                iconData: CustomIconData.sparkles,
                color: textPrimaryDarkColor,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextComponent(
                  text: getTranslated(context, AppKeys.registerNowForAccess),
                  textAlign: TextAlign.start,
                  color: textPrimaryDarkColor,
                  headerType: HeaderType.h6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ButtonComponent(
            text: getTranslated(context, AppKeys.registerNow),
            isOutLined: true,
            isWide: true,
            textPadding: 6,
            color: textPrimaryDarkColor,
            onPressed: () {
              Navigator.pushNamed(context, registerPageRoute);
            },
          ),
        ],
      ),
    );
  }
}
