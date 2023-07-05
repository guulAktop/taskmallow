import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> with TickerProviderStateMixin {
  bool isLoading = false;
  TabController? tabController;
  int _selectedTab = 0;
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    ref.read(projectProvider).isLoading = true;
    Future.delayed(Duration.zero, () async {
      ProjectModel projectArg = ModalRoute.of(context)!.settings.arguments as ProjectModel;
      await ref.read(projectProvider).getProjectById(projectArg.id).whenComplete(() {
        if (ref.read(projectProvider).projectModel == null ||
            ref.read(projectProvider).projectModel!.isDeleted ||
            !ref.read(projectProvider).projectModel!.collaborators.any((element) => element.email == ref.read(userProvider).userModel!.email)) {
          Navigator.pop(context);
        } else {
          ref.read(projectProvider).isLoading = false;
        }
      });
    });

    tabController = TabController(length: 3, vsync: this);

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
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);

    checkFavoriteStatus() async {
      if (projectRepository.projectModel != null) {
        setState(() {
          isLoading = true;
        });
        if (!projectRepository.favoriteProjects.any((element) => element.id == projectRepository.projectModel!.id)) {
          ref.read(projectProvider).favoriteProjects.insert(0, projectRepository.projectModel!);
          await userRepository
              .update(userRepository.userModel!..favoriteProjects = projectRepository.favoriteProjects.map((e) => e.id).toList())
              .whenComplete(() {
            AppFunctions()
                .showSnackbar(context, getTranslated(context, AppKeys.projectAddedFavorites), backgroundColor: successDark, icon: CustomIconData.circlePlus);
          }).onError((error, stackTrace) {
            ref.read(projectProvider).favoriteProjects.removeWhere((element) => element.id == projectRepository.projectModel!.id);
            AppFunctions()
                .showSnackbar(context, getTranslated(context, AppKeys.operationFailed), backgroundColor: dangerDark, icon: CustomIconData.circleXmark);
          });
        } else {
          ref.read(projectProvider).favoriteProjects.removeWhere((element) => element.id == projectRepository.projectModel!.id);
          await userRepository
              .update(userRepository.userModel!..favoriteProjects = projectRepository.favoriteProjects.map((e) => e.id).toList())
              .whenComplete(() {
            AppFunctions()
                .showSnackbar(context, getTranslated(context, AppKeys.projectRemovedFavorites), backgroundColor: successDark, icon: CustomIconData.circleMinus);
          }).onError((error, stackTrace) {
            ref.read(projectProvider).favoriteProjects.insert(0, projectRepository.projectModel!);
            AppFunctions()
                .showSnackbar(context, getTranslated(context, AppKeys.operationFailed), backgroundColor: dangerDark, icon: CustomIconData.circleXmark);
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    return projectRepository.isLoading
        ? const BaseScaffoldWidget(
            widgetList: [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        : BaseScaffoldWidget(
            popScopeFunction: isLoading ? () async => false : () async => true,
            title: projectRepository.projectModel != null ? projectRepository.projectModel!.name : getTranslated(context, AppKeys.projectDetails),
            leadingWidget: IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
            actionList: [
              IconButton(
                onPressed: () async {
                  handleButtonTap();
                  checkFavoriteStatus();
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
                        iconWeight: projectRepository.favoriteProjects.any((element) => element.id == projectRepository.projectModel!.id)
                            ? CustomIconWeight.solid
                            : CustomIconWeight.regular,
                      ),
                    );
                  },
                ),
              ),
              projectRepository.projectModel!.userWhoCreated.email == userRepository.userModel!.email
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, updateProjectPageRoute, arguments: projectRepository.projectModel);
                      },
                      splashRadius: AppConstants.iconSplashRadius,
                      icon: const IconComponent(iconData: CustomIconData.pen),
                    )
                  : const SizedBox(),
            ],
            widgetList: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextComponent(
                        text: projectRepository.projectModel != null ? getTranslated(context, projectRepository.projectModel!.category.name) : "",
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.bold,
                        headerType: HeaderType.h8,
                        color: primaryColor,
                      ),
                      TextComponent(
                        text: projectRepository.projectModel != null ? projectRepository.projectModel!.description : "",
                        textAlign: TextAlign.start,
                        headerType: HeaderType.h5,
                      ),
                      TextComponent(
                        text: projectRepository.projectModel != null ? projectRepository.projectModel!.userWhoCreated.email : "",
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                        headerType: HeaderType.h8,
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
                              "${(AppFunctions().getPercentageOfCompletion(projectRepository.projectModel!) * 100).toStringAsFixed(0)}% ${getTranslated(context, AppKeys.completed)}",
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
                          value: AppFunctions().getPercentageOfCompletion(projectRepository.projectModel!),
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
                          children: ref
                              .watch(projectProvider)
                              .projectModel!
                              .collaborators
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
                              .toList()
                            ..add(
                              projectRepository.projectModel!.userWhoCreated.email == userRepository.userModel!.email
                                  ? Container(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                          child: Material(
                                            color: primaryColor,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context, collaboratorsPageRoute);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                child: const IconComponent(
                                                  iconData: CustomIconData.plus,
                                                  color: textPrimaryDarkColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: secondaryColor, thickness: 1),
                  ),
                  projectRepository.projectModel!.userWhoCreated.email == userRepository.userModel!.email
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ButtonComponent(
                            text: getTranslated(context, AppKeys.newTask),
                            isOutLined: true,
                            isWide: true,
                            onPressed: () {
                              Navigator.pushNamed(context, createTaskPageRoute);
                            },
                          ),
                        )
                      : const SizedBox(),
                  Center(
                    child: TabBar(
                      onTap: (value) {
                        setState(() {
                          _selectedTab = value;
                        });
                        debugPrint(_selectedTab.toString());
                      },
                      splashBorderRadius: const BorderRadius.all(Radius.circular(50)),
                      physics: const BouncingScrollPhysics(),
                      controller: tabController,
                      labelColor: primaryColor,
                      isScrollable: true,
                      unselectedLabelColor: Colors.black,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextComponent(text: getTranslated(context, TaskSituation.to_do.name)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextComponent(text: getTranslated(context, TaskSituation.in_progress.name)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextComponent(text: getTranslated(context, TaskSituation.done.name)),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (_selectedTab == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: projectRepository.projectModel!.tasks
                                .where((element) => element.situation == TaskSituation.to_do && !element.isDeleted)
                                .map((task) => getTaskRow(task, ref.watch(projectProvider).projectModel!))
                                .toList(),
                          ),
                        );
                      } else if (_selectedTab == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: projectRepository.projectModel!.tasks
                                .where((element) => element.situation == TaskSituation.in_progress && !element.isDeleted)
                                .map((task) => getTaskRow(task, ref.watch(projectProvider).projectModel!))
                                .toList(),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: projectRepository.projectModel!.tasks
                                .where((element) => element.situation == TaskSituation.done && !element.isDeleted)
                                .map((task) => getTaskRow(task, ref.watch(projectProvider).projectModel!))
                                .toList(),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ],
          );
  }

  Widget getTaskRow(TaskModel taskModel, ProjectModel projectModel) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (ref.watch(projectProvider).projectModel!.userWhoCreated.email == ref.watch(userProvider).userModel!.email) {
            Navigator.pushNamed(context, updateTaskPageRoute, arguments: taskModel);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                MarqueeWidget(
                  child: TextComponent(
                    text: taskModel.viewId,
                    color: primaryColor,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MarqueeWidget(
                    child: TextComponent(
                      text: taskModel.name,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      softWrap: true,
                      maxLines: 1,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: PopupMenuWidget(
                    menuList: generatePopup(taskModel),
                  ),
                ),
              ],
            ),
            TextComponent(
              text: taskModel.description,
              textAlign: TextAlign.start,
              headerType: HeaderType.h6,
            ),
            taskModel.assignedUserMail != null
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularPhotoComponent(
                              url: projectModel.collaborators.any((element) => element.email == taskModel.assignedUserMail)
                                  ? projectModel.collaborators.where((element) => element.email == taskModel.assignedUserMail).first.profilePhotoURL
                                  : null,
                              hasBorder: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
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
                if (ref.watch(projectProvider).projectModel != null) {
                  taskModel.situation = TaskSituation.to_do;
                  ref.watch(projectProvider).updateTask(taskModel).whenComplete(() {
                    debugPrint("Güncel Task Durumu: ${taskModel.situation}");
                  });
                }
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
                if (ref.watch(projectProvider).projectModel != null) {
                  taskModel.situation = TaskSituation.in_progress;
                  ref.watch(projectProvider).updateTask(taskModel).whenComplete(() {
                    debugPrint("Güncel Task Durumu: ${taskModel.situation}");
                  });
                }
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
                if (ref.watch(projectProvider).projectModel != null) {
                  taskModel.situation = TaskSituation.done;
                  ref.watch(projectProvider).updateTask(taskModel).whenComplete(() {
                    debugPrint("Güncel Task Durumu: ${taskModel.situation}");
                  });
                }
              },
            ),
          )
        : null;

    popupMenuList.add(menuList);
    return popupMenuList;
  }
}
