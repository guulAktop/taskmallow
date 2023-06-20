import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/settings_pages/settings_bottom_sheet_dialog_pages/language_settings_page.dart';
import 'package:taskmallow/pages/settings_pages/settings_bottom_sheet_dialog_pages/privacy_policy_page.dart';
import 'package:taskmallow/pages/settings_pages/settings_bottom_sheet_dialog_pages/theme_settings_page.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/list_view_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.settings),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      actionList: [
        IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.arrowRightFromBracket),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                content: TextComponent(text: getTranslated(context, AppKeys.aysLogOut), textAlign: TextAlign.start, headerType: HeaderType.h5),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(getTranslated(context, AppKeys.yes)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(getTranslated(context, AppKeys.no)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
      widgetList: [
        ListViewWidget(
          backgroundColor: listViewItemBackgroundLightColor,
          dividerColor: Colors.black.withOpacity(0.25),
          itemList: [
            ListViewItem(
              title: getTranslated(context, AppKeys.language),
              prefixWidget: const IconComponent(iconData: CustomIconData.earthAmericas),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return LanguageSettingsPage(title: getTranslated(context, AppKeys.language));
                  },
                );
              },
            ),
            ListViewItem(
              title: getTranslated(context, AppKeys.theme),
              prefixWidget: const IconComponent(iconData: CustomIconData.palette),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ThemeSettingsPage(title: getTranslated(context, AppKeys.theme));
                  },
                );
              },
            ),
          ],
        ),
        ListViewWidget(
          backgroundColor: listViewItemBackgroundLightColor,
          dividerColor: Colors.black.withOpacity(0.25),
          itemList: [
            ListViewItem(
              title: getTranslated(context, AppKeys.privacyPolicy),
              prefixWidget: const IconComponent(iconData: CustomIconData.fileShield),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return PrivacyPolicyPage(title: getTranslated(context, AppKeys.privacyPolicy));
                  },
                );
              },
            ),
            ListViewItem(
              title: getTranslated(context, AppKeys.deleteMyAccount),
              foregroundColor: danger,
              prefixWidget: const IconComponent(iconData: CustomIconData.userSlash, color: danger),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    content: TextComponent(text: getTranslated(context, AppKeys.aysDeleteAccount), textAlign: TextAlign.start, headerType: HeaderType.h5),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text(getTranslated(context, AppKeys.yes)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text(getTranslated(context, AppKeys.no)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const Spacer(),
        ListViewWidget(
          backgroundColor: listViewItemBackgroundLightColor,
          itemList: [
            ListViewItem(
              prefixWidget: const IconComponent(iconData: CustomIconData.code),
              title: "v.1.0.0",
            )
          ],
        ),
      ],
    );
  }
}
