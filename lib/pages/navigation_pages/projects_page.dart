import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/project_row_item.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.projects),
      actionList: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, favoriteProjectsPageRoute);
          },
          icon: const IconComponent(iconData: CustomIconData.stars),
          splashRadius: AppConstants.iconSplashRadius,
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const IconComponent(iconData: CustomIconData.plus, color: textPrimaryDarkColor),
        onPressed: () {
          Navigator.pushNamed(context, createProjectPageRoute);
        },
      ),
      widgetList: projects
          .map((project) => ProjectRowItem(
                project: project,
                onTap: () {
                  Navigator.pushNamed(context, projectDetailPageRoute, arguments: project);
                },
              ))
          .toList(),
    );
  }
}
