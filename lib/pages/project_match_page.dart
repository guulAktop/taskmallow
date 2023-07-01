import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/project_grid_item.dart';
import 'package:taskmallow/widgets/sliver_scaffold_widget.dart';

class ProjectMatchPage extends ConsumerStatefulWidget {
  const ProjectMatchPage({super.key});

  @override
  ConsumerState<ProjectMatchPage> createState() => _ProjectMatchPageState();
}

class _ProjectMatchPageState extends ConsumerState<ProjectMatchPage> with TickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.5, -0.5),
    ).animate(_controller);

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: pi / 4,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();

    ref.read(projectProvider).isLoading = true;
    Future.delayed(const Duration(milliseconds: 3000), () async {
      await ref.read(projectProvider).getMatchingProjects(ref.read(userProvider).userModel!).then((value) {
        ref.read(projectProvider).isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
    return projectRepository.isLoading
        ? BaseScaffoldWidget(
            hasAppBar: false,
            widgetList: [
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconComponent(iconData: CustomIconData.database, color: matchItemBackgroundColor, size: UIHelper.getDeviceWidth(context) / 4),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: IconComponent(iconData: CustomIconData.magnifyingGlass, color: matchColor, size: UIHelper.getDeviceWidth(context) / 8),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : SliverScaffoldWidget(
            title: getTranslated(context, AppKeys.yourMatches),
            leadingWidget: IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
            widgetList: projectRepository.matchingProjects.isNotEmpty
                ? [
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
                              projectModel: projectRepository.matchingProjects[index],
                              containerColor: matchItemBackgroundColor,
                              indicatorBackgroundColor: matchSecondaryColor,
                              indicatorForegroundColor: matchColor,
                              onTap: () {
                                if (projectRepository.matchingProjects[index].collaborators
                                    .map((collaborator) => collaborator.email)
                                    .toList()
                                    .contains(userRepository.userModel!.email)) {
                                  Navigator.pushNamed(context, projectDetailPageRoute, arguments: projectRepository.matchingProjects[index]);
                                } else {
                                  Navigator.pushNamed(context, projectScreenPageRoute, arguments: projectRepository.matchingProjects[index]);
                                }
                              },
                            );
                          },
                          childCount: projectRepository.matchingProjects.length,
                        ),
                      ),
                    ),
                  ]
                : [
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: matchItemBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              IconComponent(
                                  iconData: CustomIconData.faceFrown,
                                  color: matchColor,
                                  iconWeight: CustomIconWeight.regular,
                                  size: UIHelper.getDeviceWidth(context) / 10),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextComponent(
                                  text: getTranslated(context, AppKeys.noProjectMatching),
                                  color: matchColor,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
          );
  }
}
