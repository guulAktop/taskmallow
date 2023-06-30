import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class FavoriteProjectsPage extends ConsumerStatefulWidget {
  const FavoriteProjectsPage({super.key});

  @override
  ConsumerState<FavoriteProjectsPage> createState() => _FavoriteProjectsPageState();
}

class _FavoriteProjectsPageState extends ConsumerState<FavoriteProjectsPage> with TickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
    return SliverScaffoldWidget(
      title: getTranslated(context, AppKeys.favoriteProjects),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: projectRepository.favoriteProjects.isNotEmpty
          ? [
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(),
                  ],
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
                        projectModel: projectRepository.favoriteProjects[index],
                        onTap: () {
                          ref.read(projectProvider).projectModel = projectRepository.favoriteProjects[index];
                          if (projectRepository.favoriteProjects[index].collaborators
                              .map((collaborator) => collaborator.email)
                              .toList()
                              .contains(userRepository.userModel!.email)) {
                            Navigator.pushNamed(context, projectDetailPageRoute, arguments: projectRepository.favoriteProjects[index]);
                          } else {
                            Navigator.pushNamed(context, projectScreenPageRoute, arguments: projectRepository.favoriteProjects[index]);
                          }
                        },
                      );
                    },
                    childCount: projectRepository.favoriteProjects.length,
                  ),
                ),
              ),
            ]
          : [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: SizedBox(
                    width: UIHelper.getDeviceWidth(context) / 3,
                    child: Image.asset(
                      ImageAssetKeys.emptyFavoriteProjects,
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
