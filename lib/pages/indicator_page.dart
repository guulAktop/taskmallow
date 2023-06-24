import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
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
  Future<String?> getFutureFromSP() async {
    String? loggedUser = await SharedPreferencesHelper.getString("loggedUser");
    return loggedUser;
  }

  Future<void> getFuture() async {
    UserRepository userRepository = ref.read(userProvider);
    getFutureFromSP().then((loggedUserSP) {
      if (loggedUserSP != null && loggedUserSP.toString().isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userRepository.userModel = UserModel.fromJson(jsonDecode(loggedUserSP.toString()));
          userRepository.hasProfile(userRepository.userModel!.email).then((value) {
            if (value) {
              userRepository.getUser(userRepository.userModel!.email).whenComplete(() async {
                String? token = await getToken();
                debugPrint('user token: $token');
                userRepository.updateNotificationToken(token ?? '').whenComplete(() {
                  userRepository.setLoggedUser().whenComplete(() {
                    userRepository.userInfoFull(userRepository.userModel!.email).whenComplete(() {
                      if (mounted) {
                        if (userRepository.userInfoIsFull) {
                          if (userRepository.userModel!.preferredCategories.isEmpty) {
                            Navigator.pushNamedAndRemoveUntil(context, categoryPreferencesPageRoute, (route) => false, arguments: 0);
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
                          }
                          debugPrint("user info full");
                        } else {
                          Navigator.pushNamedAndRemoveUntil(context, updateProfilePageRoute, (route) => false, arguments: 1);
                          debugPrint("user info not full");
                        }
                      }
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
            userRepository.userModel = null;
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
          } else if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, onboardingPageRoute, (route) => false);
          }
        });
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
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
                    child: Container(
                      color: primaryColor,
                      child: Image.asset(
                        ImageAssetKeys.launcherIcon,
                        width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 4 : UIHelper.getDeviceHeight(context) / 4,
                      ),
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
