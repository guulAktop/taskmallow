import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndicatorPage extends ConsumerStatefulWidget {
  const IndicatorPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends ConsumerState<IndicatorPage> {
  Future<void> getFuture() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedPageIndexProvider.notifier).state = 0;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ref.read(appVersionProvider.notifier).state = packageInfo.version;
    UserRepository userRepository = ref.read(userProvider);
    ProjectRepository projectRepository = ref.read(projectProvider);
    await SharedPreferencesHelper.getString("loggedUser").then((loggedUserSP) {
      if (loggedUserSP != null && loggedUserSP.toString().isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userRepository.filteredProjects.clear();
          userRepository.filteredUsers.clear();
          userRepository.incomingInvitations.clear();
          userRepository.outgoingInvitations.clear();
          projectRepository.allRelatedProjects.clear();
          projectRepository.favoriteProjects.clear();
          projectRepository.invitations.clear();
          projectRepository.latestProjects.clear();
          projectRepository.matchingProjects.clear();
          projectRepository.matchingUsers.clear();
          userRepository.userModel = UserModel.fromJson(jsonDecode(loggedUserSP.toString()));
          userRepository.hasProfile(userRepository.userModel!.email).then((value) {
            if (value) {
              userRepository.getUser(userRepository.userModel!.email).whenComplete(() async {
                String? token = await FirebaseMessaging.instance.getToken();
                userRepository.updateNotificationToken(token ?? '').whenComplete(() {
                  userRepository.setLoggedUser().whenComplete(() {
                    userRepository.userInfoFull(userRepository.userModel!.email).whenComplete(() {
                      projectRepository.getAllRelatedProjects(userRepository.userModel!).whenComplete(() {
                        projectRepository.getLatestProjects().whenComplete(() {
                          projectRepository.getFavoriteProjects(userRepository.userModel!).whenComplete(() {
                            userRepository.updateUserLocale(Localizations.localeOf(context).languageCode).whenComplete(() async {
                              await userRepository.listenInvitations();
                              if (mounted) {
                                if (userRepository.userInfoIsFull) {
                                  if (userRepository.userModel!.preferredCategories.isEmpty) {
                                    Navigator.pushNamedAndRemoveUntil(context, categoryPreferencesPageRoute, (route) => false, arguments: 0);
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
                                  }
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(context, updateProfilePageRoute, (route) => false, arguments: 1);
                                }
                              }
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            } else {
              ref.read(userProvider).logout(context);
            }
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          bool? onboardingPagesShown = await SharedPreferencesHelper.getBool("onboardingPagesShown");
          if (onboardingPagesShown != null && onboardingPagesShown) {
            projectRepository.getLatestProjects().whenComplete(() {
              userRepository.userModel = null;
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, noUserPageRoute, (route) => false);
            });
          } else if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, onboardingPageRoute, (route) => false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FutureBuilder(
        future: getFuture(),
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BaseScaffoldWidget(
              hasAppBar: false,
              widgetList: [
                const Spacer(),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      ImageAssetKeys.launcherIcon,
                      width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.6 : UIHelper.getDeviceHeight(context) / 2.6,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
