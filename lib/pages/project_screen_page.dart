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
import 'package:taskmallow/models/invitation_model.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

import '../models/user_model.dart';

class ProjectScreenPage extends ConsumerStatefulWidget {
  const ProjectScreenPage({super.key});

  @override
  ConsumerState<ProjectScreenPage> createState() => _ProjectScreenPageState();
}

class _ProjectScreenPageState extends ConsumerState<ProjectScreenPage> with TickerProviderStateMixin {
  bool isLoading = false;
  int? maxlines = 5;
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    ref.read(projectProvider).isLoading = true;
    Future.delayed(Duration.zero, () async {
      ProjectModel projectArg = ModalRoute.of(context)!.settings.arguments as ProjectModel;
      await ref.read(projectProvider).getProject(projectArg.id).whenComplete(() {
        if (ref.read(projectProvider).projectModel != null && ref.read(userProvider).userModel != null) {
          if (ref.read(projectProvider).projectModel!.collaborators.any((element) => element.email == ref.read(userProvider).userModel!.email)) {
            Navigator.pushReplacementNamed(context, projectDetailPageRoute, arguments: ref.read(projectProvider).projectModel!);
          }
        }
        ref.read(projectProvider).isLoading = false;
      });
    });

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
        : RefreshIndicator(
            onRefresh: () async {
              if (ref.watch(projectProvider).projectModel != null) {
                await ref.watch(projectProvider).getProject(ref.watch(projectProvider).projectModel!.id);
              }
            },
            child: BaseScaffoldWidget(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              popScopeFunction: isLoading ? () async => false : () async => true,
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
              ],
              widgetList: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextComponent(
                          text: projectRepository.projectModel != null ? projectRepository.projectModel!.name : "",
                          textAlign: TextAlign.start,
                          headerType: HeaderType.h4,
                          fontWeight: FontWeight.bold,
                        ),
                        TextComponent(
                          text: projectRepository.projectModel != null ? getTranslated(context, projectRepository.projectModel!.category.name) : "",
                          textAlign: TextAlign.end,
                          fontWeight: FontWeight.bold,
                          headerType: HeaderType.h7,
                          color: primaryColor,
                        ),
                        TextComponent(
                          text: projectRepository.projectModel != null ? projectRepository.projectModel!.description : "",
                          textAlign: TextAlign.start,
                          headerType: HeaderType.h5,
                          maxLines: maxlines,
                          overflow: maxlines != null ? TextOverflow.ellipsis : null,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              if (maxlines != null) {
                                maxlines = null;
                              } else {
                                maxlines = 5;
                              }
                            });
                          },
                          child: TextComponent(
                            text: maxlines == null ? getTranslated(context, AppKeys.showLess) : getTranslated(context, AppKeys.showMore),
                            color: Colors.grey,
                            textAlign: TextAlign.start,
                            headerType: HeaderType.h7,
                          ),
                        ),
                        TextComponent(
                          text: projectRepository.projectModel != null ? projectRepository.projectModel!.userWhoCreated.email : "",
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
                                  .map((user) => InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        onTap: () {
                                          if (user.email == ref.watch(userProvider).userModel!.email) {
                                            Navigator.pushNamed(context, profilePageRoute, arguments: user);
                                          } else {
                                            Navigator.pushNamed(context, profileScreenPageRoute, arguments: user);
                                          }
                                        },
                                        child: Container(
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
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: secondaryColor, thickness: 1),
                    ),
                    ref.watch(userProvider).incomingInvitations.any((element) => element.project.id == projectRepository.projectModel!.id)
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: infoDark, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Row(
                              children: [
                                const IconComponent(
                                  iconData: CustomIconData.envelope,
                                  color: textPrimaryDarkColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextComponent(
                                      text: getTranslated(context, AppKeys.youHaveBeenInvited), color: textPrimaryDarkColor, textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                          )
                        : ButtonComponent(
                            text: userRepository.outgoingInvitations.any((element) => element.project.id == projectRepository.projectModel!.id)
                                ? getTranslated(context, AppKeys.takeItBack)
                                : getTranslated(context, AppKeys.sendJoinRequest),
                            color: userRepository.outgoingInvitations.any((element) => element.project.id == projectRepository.projectModel!.id)
                                ? dangerDark
                                : primaryColor,
                            isOutLined: true,
                            onPressed: () async {
                              if (ref.watch(userProvider).incomingInvitations.any((element) => element.project.id == projectRepository.projectModel!.id)) {
                                AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.youHaveBeenInvited),
                                    icon: CustomIconData.envelope, backgroundColor: infoDark);
                              } else {
                                if (!userRepository.outgoingInvitations.any((element) => element.project.id == projectRepository.projectModel!.id)) {
                                  InvitationModel invitationModel = InvitationModel(
                                      fromUser: userRepository.userModel!,
                                      toUser: projectRepository.projectModel!.userWhoCreated,
                                      project: projectRepository.projectModel!);
                                  await userRepository.sendInvitation(invitationModel).whenComplete(() async {
                                    UserModel user = await userRepository.getUserByEmail(invitationModel.toUser.email);
                                    String title = await AppFunctions().getTranslatedByLocale(user.languageCode, AppKeys.newInvitation);
                                    String body1 = await AppFunctions().getTranslatedByLocale(user.languageCode, AppKeys.wantsToBeInvolved1);
                                    String body2 = await AppFunctions().getTranslatedByLocale(user.languageCode, AppKeys.wantsToBeInvolved2);

                                    await AppFunctions().sendPushMessage(user, title,
                                        "${invitationModel.fromUser.firstName} ${invitationModel.fromUser.lastName}$body1${invitationModel.project.name}$body2");
                                  });
                                } else {
                                  await userRepository
                                      .removeInvitation(
                                          userRepository.outgoingInvitations.where((element) => element.project.id == projectRepository.projectModel!.id).first)
                                      .whenComplete(() {
                                    projectRepository.listenForInvitationsByProject();
                                  });
                                }
                              }
                            },
                          )
                  ],
                ),
              ],
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
