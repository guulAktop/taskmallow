import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class CategoryPreferencesPage extends ConsumerStatefulWidget {
  const CategoryPreferencesPage({super.key});

  @override
  ConsumerState<CategoryPreferencesPage> createState() => _CategoryPreferencesPageState();
}

class _CategoryPreferencesPageState extends ConsumerState<CategoryPreferencesPage> {
  bool isLoading = false;
  List<String> selectedSubtitles = [];

  @override
  void initState() {
    super.initState();
    UserRepository userRepository = ref.read(userProvider);
    selectedSubtitles = [];
    if (userRepository.userModel != null) {
      selectedSubtitles.addAll(userRepository.userModel!.preferredCategories);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    int? pageType = ModalRoute.of(context)!.settings.arguments as int?;
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.categories),
      leadingWidget: pageType == 0
          ? null
          : IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
      actionList: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: TextButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (selectedSubtitles.isEmpty) {
                      AppFunctions().showSnackbar(context, getTranslated(context, AppKeys.youMustSelectCategory),
                          backgroundColor: warningDark, icon: CustomIconData.listCheck);
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      if (userRepository.userModel != null) {
                        await userRepository.update(userRepository.userModel!..preferredCategories = selectedSubtitles).then((value) {
                          if (userRepository.isSucceeded) {
                            userRepository.userModel!.preferredCategories = selectedSubtitles;
                            if (pageType == 0) {
                              Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        });
                      } else {
                        userRepository.logout(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
            child: TextComponent(
              maxLines: 1,
              text: getTranslated(context, AppKeys.done),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      widgetList: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextComponent(
              text: getTranslated(context, AppKeys.addTheCategories),
              textAlign: TextAlign.start,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: secondaryColor, thickness: 1),
            ),
            TextComponent(
              text: getTranslated(context, AppKeys.preferredCategories),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: itemBackgroundLightColor,
              ),
              padding: const EdgeInsets.all(10),
              child: selectedSubtitles.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedSubtitles.map((item) => buildItemContainer(item)).toList(),
                    )
                  : const IconComponent(
                      iconData: CustomIconData.listCheck,
                      color: primaryColor,
                      size: 35,
                    ),
            ),
            const SizedBox(height: 20),
            TextComponent(
              text: getTranslated(context, AppKeys.categories),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
              headerType: HeaderType.h6,
              softWrap: true,
            ),
            const SizedBox(height: 10),
            Column(
              children: CategoryConstants().titles.map((title) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: itemBackgroundLightColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      title: MarqueeWidget(
                        child: Text(
                          getTranslated(context, title),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      children: CategoryConstants()
                          .subtitleMap[title]!
                          .map(
                            (subtitle) => Material(
                              color: Colors.transparent,
                              child: ListTile(
                                title: MarqueeWidget(
                                  animationDuration: const Duration(milliseconds: 1000),
                                  child: TextComponent(
                                    text: getTranslated(context, subtitle),
                                    textAlign: TextAlign.start,
                                    color: selectedSubtitles.contains(subtitle) ? successDark : textPrimaryLightColor,
                                  ),
                                ),
                                onTap: () {
                                  if (!selectedSubtitles.contains(subtitle)) {
                                    setState(() {
                                      selectedSubtitles.add(subtitle);
                                    });
                                  }
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildItemContainer(String item) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: MarqueeWidget(
              child: TextComponent(
                text: getTranslated(context, item),
                headerType: HeaderType.h7,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              onTap: () {
                setState(() {
                  selectedSubtitles.remove(item);
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: IconComponent(iconData: CustomIconData.xmark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
