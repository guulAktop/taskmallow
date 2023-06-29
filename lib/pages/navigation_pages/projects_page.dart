import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/project_row_item.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
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
      widgetList: projectRepository.allRelatedProjects.isNotEmpty
          ? projectRepository.allRelatedProjects
              .map((project) => ProjectRowItem(
                    projectModel: project,
                    onTap: () {
                      ref.read(projectProvider).projectModel = project;
                      if (project.collaborators.map((collaborator) => collaborator.email).toList().contains(userRepository.userModel!.email)) {
                        Navigator.pushNamed(context, projectDetailPageRoute, arguments: project);
                      } else {
                        Navigator.pushNamed(context, projectScreenPageRoute, arguments: project);
                      }
                    },
                  ))
              .toList()
          : [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: UIHelper.getDeviceWidth(context) / 3,
                    child: Image.asset(
                      ImageAssetKeys.emptyFolder,
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
