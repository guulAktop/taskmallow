import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/constants/task_situations_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class ProjectScreenPage extends StatefulWidget {
  const ProjectScreenPage({super.key});

  @override
  State<ProjectScreenPage> createState() => _ProjectScreenPageState();
}

class _ProjectScreenPageState extends State<ProjectScreenPage> with TickerProviderStateMixin {
  bool isLoading = false;

  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<ProjectModel> favoriteProjects = [];

  ProjectModel? projectModel;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var arg = _getProjectModelFromArguments();
    if (arg != null) {
      projectModel = arg;
    }
  }

  ProjectModel? _getProjectModelFromArguments() {
    ModalRoute? route = ModalRoute.of(context);
    dynamic arguments = route?.settings.arguments;
    if (arguments is ProjectModel) {
      return arguments;
    } else {
      Navigator.pop(context);
    }
    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleButtonTap() {
    setState(() {
      isExpanded = true;
    });

    _animationController.forward().whenComplete(() {
      setState(() {
        isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: projectModel != null ? projectModel!.name : "",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        IconButton(
          onPressed: () {
            handleButtonTap();
            if (projectModel != null) {
              if (!favoriteProjects.contains(projectModel)) {
                setState(() {
                  favoriteProjects.add(projectModel!);
                });
              } else {
                setState(() {
                  favoriteProjects.remove(projectModel);
                });
              }
            }
          },
          splashRadius: AppConstants.iconSplashRadius,
          icon: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: isExpanded ? _animation.value : 1.0,
                child: IconComponent(
                  iconData: CustomIconData.star,
                  color: primaryColor,
                  iconWeight: favoriteProjects.contains(projectModel) ? CustomIconWeight.solid : CustomIconWeight.regular,
                ),
              );
            },
          ),
        ),
      ],
      widgetList: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextComponent(
                  text: projectModel != null ? getTranslated(context, projectModel!.category.name) : "",
                  textAlign: TextAlign.end,
                  fontWeight: FontWeight.bold,
                  headerType: HeaderType.h8,
                  color: primaryColor,
                ),
                TextComponent(
                  text: projectModel != null ? projectModel!.description : "",
                  textAlign: TextAlign.start,
                  headerType: HeaderType.h6,
                ),
                TextComponent(
                  text: projectModel != null ? projectModel!.userWhoCreated.email : "",
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  headerType: HeaderType.h7,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MarqueeWidget(
                  child: TextComponent(
                    text:
                        "${(tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length * 100).toStringAsFixed(0)}% ${getTranslated(context, AppKeys.completed)}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    headerType: HeaderType.h7,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: LinearProgressIndicator(
                    minHeight: 20,
                    value: (tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length).toDouble(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextComponent(
                  text: getTranslated(context, AppKeys.collaborators),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: users
                        .map((user) => Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularPhotoComponent(url: user.profilePhotoURL, hasBorder: false),
                                  ),
                                  TextComponent(
                                    text: user.firstName[0] + user.lastName[0],
                                    headerType: HeaderType.h6,
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: secondaryColor, thickness: 1),
            ),
            ButtonComponent(
              text: getTranslated(context, AppKeys.sendJoinRequest),
              isOutLined: true,
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  }

  List<List<PopupMenuWidgetItem>> generatePopup(TaskModel taskModel) {
    List<List<PopupMenuWidgetItem>> popupMenuList = [];
    List<PopupMenuWidgetItem> menuList = [];

    taskModel.situation.name != TaskSituation.to_do.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.to_do.name),
              prefixIcon: CustomIconData.list,
              color: primaryColor,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.to_do;
                });
              },
            ),
          )
        : null;

    taskModel.situation.name != TaskSituation.in_progress.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.in_progress.name),
              prefixIcon: CustomIconData.spinner,
              color: warningDark,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.in_progress;
                });
              },
            ),
          )
        : null;

    taskModel.situation.name != TaskSituation.done.name
        ? menuList.add(
            PopupMenuWidgetItem(
              title: getTranslated(context, TaskSituation.done.name),
              prefixIcon: CustomIconData.circleCheck,
              color: success,
              function: () {
                setState(() {
                  taskModel.situation = TaskSituation.done;
                });
              },
            ),
          )
        : null;

    popupMenuList.add(menuList);
    return popupMenuList;
  }
}
