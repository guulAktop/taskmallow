import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/shared_preferences_keys.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/list_view_widget.dart';

class ThemeSettingsPage extends StatefulWidget {
  final String title;
  const ThemeSettingsPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool isLoading = true;

  setDarkTheme(bool isDarkThemeValue) async {
    await SharedPreferencesHelper.setBool("isDarkTheme", isDarkThemeValue);
  }

  setUseDeviceTheme(bool isDarkThemeValue) async {
    await SharedPreferencesHelper.setBool("useDeviceTheme", isDarkThemeValue);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(title: widget.title, widgetList: [
      ListViewWidget(
        backgroundColor: listViewItemBackgroundLightColor,
        dividerColor: Colors.black.withOpacity(0.25),
        itemList: [
          ListViewItem(
            onTap: () {
              setState(() {
                setUseDeviceTheme(!SharedPreferencesKeys.useDeviceTheme);
                SharedPreferencesKeys.useDeviceTheme = !SharedPreferencesKeys.useDeviceTheme;
              });
            },
            title: getTranslated(context, AppKeys.useDeviceTheme),
            suffixWidget: Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: primaryColor,
                value: SharedPreferencesKeys.useDeviceTheme,
                onChanged: (value) {
                  setState(() {
                    setUseDeviceTheme(!SharedPreferencesKeys.useDeviceTheme);
                    SharedPreferencesKeys.useDeviceTheme = !SharedPreferencesKeys.useDeviceTheme;
                  });
                },
              ),
            ),
          ),
          SharedPreferencesKeys.useDeviceTheme == false
              ? ListViewItem(
                  onTap: () {
                    setState(() {
                      setDarkTheme(!SharedPreferencesKeys.isDarkTheme);
                      SharedPreferencesKeys.isDarkTheme = !SharedPreferencesKeys.isDarkTheme;
                    });
                  },
                  title: getTranslated(context, AppKeys.darkTheme),
                  suffixWidget: Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      activeColor: primaryColor,
                      value: SharedPreferencesKeys.isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          setDarkTheme(!SharedPreferencesKeys.isDarkTheme);
                          SharedPreferencesKeys.isDarkTheme = !SharedPreferencesKeys.isDarkTheme;
                        });
                      },
                    ),
                  ),
                )
              : ListViewItem(title: "", isVisible: false),
        ],
      ),
    ]);
  }
}
