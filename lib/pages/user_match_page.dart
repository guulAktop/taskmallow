import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class UserMatchPage extends ConsumerStatefulWidget {
  const UserMatchPage({super.key});

  @override
  ConsumerState<UserMatchPage> createState() => _UserMatchPageState();
}

class _UserMatchPageState extends ConsumerState<UserMatchPage> with TickerProviderStateMixin {
  bool isLoading = false;
  List<UserModel> invitedUsers = [];
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
      await ref.read(projectProvider).getMatchingUsers().then((value) {
        ref.read(projectProvider).isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
    userRepository.userModel!.preferredCategories;
    return projectRepository.isLoading
        ? BaseScaffoldWidget(
            hasAppBar: false,
            widgetList: [
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconComponent(
                          iconData: CustomIconData.earthEurope,
                          iconWeight: CustomIconWeight.regular,
                          color: matchItemBackgroundColor,
                          size: UIHelper.getDeviceWidth(context) / 4),
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
        : BaseScaffoldWidget(
            title: getTranslated(context, AppKeys.yourMatches),
            leadingWidget: IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
            widgetList: projectRepository.matchingUsers.isNotEmpty
                ? [
                    TextComponent(
                      text: getTranslated(context, AppKeys.hereAreTheUsers),
                      textAlign: TextAlign.center,
                    ),
                    TextComponent(
                      text: getTranslated(context, AppKeys.takeALook),
                      color: matchColor,
                      fontWeight: FontWeight.bold,
                      headerType: HeaderType.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: projectRepository.matchingUsers.map((user) => getUserRow(user)).toList(),
                    ),
                  ]
                : [
                    Container(
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
                              text: getTranslated(context, AppKeys.noUserMatching),
                              color: matchColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
          );
  }

  Widget getUserRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: matchItemBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (user.email == ref.watch(userProvider).userModel!.email) {
            Navigator.pushNamed(context, profilePageRoute, arguments: user);
          } else {
            Navigator.pushNamed(context, profileScreenPageRoute, arguments: user);
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: UIHelper.getDeviceWidth(context) / 7,
              height: UIHelper.getDeviceWidth(context) / 7,
              child: CircularPhotoComponent(
                url: user.profilePhotoURL,
                hasBorder: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                    child: TextComponent(
                      text: "${user.firstName} ${user.lastName}",
                      fontWeight: FontWeight.bold,
                      headerType: HeaderType.h4,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  MarqueeWidget(
                    child: TextComponent(
                      text: user.email,
                      headerType: HeaderType.h7,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  tooltip: !invitedUsers.contains(user) ? getTranslated(context, AppKeys.invite) : getTranslated(context, AppKeys.removeInvite),
                  onPressed: () {
                    if (!invitedUsers.contains(user)) {
                      setState(() {
                        invitedUsers.add(user);
                      });
                    } else {
                      setState(() {
                        invitedUsers.remove(user);
                      });
                    }
                  },
                  icon: IconComponent(
                    iconData: !invitedUsers.contains(user) ? CustomIconData.paperPlane : CustomIconData.circleXmark,
                    color: !invitedUsers.contains(user) ? matchColor : dangerDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
