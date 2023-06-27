import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class FavoriteProjectsPage extends StatefulWidget {
  const FavoriteProjectsPage({super.key});

  @override
  State<FavoriteProjectsPage> createState() => _FavoriteProjectsPageState();
}

class _FavoriteProjectsPageState extends State<FavoriteProjectsPage> with TickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffoldWidget(
      title: getTranslated(context, AppKeys.favoriteProjects),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
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
}
