import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return SliverScaffoldWidget(
      centerTitle: false,
      leadingWidth: 0,
      title: "${getTranslated(context, AppKeys.hello)} ${userRepository.userModel!.firstName}",
      actionList: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, searchPageRoute);
          },
          icon: const IconComponent(
            iconData: CustomIconData.magnifyingGlass,
          ),
          splashRadius: AppConstants.iconSplashRadius,
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, invitationsPageRoute);
          },
          icon: const IconComponent(
            iconData: CustomIconData.bell,
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
              text: getTranslated(context, AppKeys.someProjects),
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
