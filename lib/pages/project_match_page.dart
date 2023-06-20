import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class ProjectMatchPage extends StatefulWidget {
  const ProjectMatchPage({super.key});

  @override
  State<ProjectMatchPage> createState() => _ProjectMatchPageState();
}

class _ProjectMatchPageState extends State<ProjectMatchPage> with TickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffoldWidget(
      title: getTranslated(context, AppKeys.yourMatches),
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
                TextComponent(
                  text: getTranslated(context, AppKeys.hereAreTheProjects),
                  textAlign: TextAlign.center,
                ),
                TextComponent(
                  text: getTranslated(context, AppKeys.takeALook),
                  color: matchColor,
                  fontWeight: FontWeight.bold,
                  headerType: HeaderType.h3,
                  textAlign: TextAlign.center,
                ),
              ],
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
                  containerColor: matchItemBackgroundColor,
                  indicatorBackgroundColor: matchSecondaryColor,
                  indicatorForegroundColor: matchColor,
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
}
