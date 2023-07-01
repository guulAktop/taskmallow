import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/navigation_pages/home_page.dart';
import 'package:taskmallow/pages/navigation_pages/projects_page.dart';
import 'package:taskmallow/pages/navigation_pages/profile_page.dart';
import 'package:taskmallow/providers/providers.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(selectedPageIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const <Widget>[
          HomePage(),
          ProjectsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: appBackgroundLightColor,
        selectedItemColor: primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconComponent(
              iconData: CustomIconData.house,
              size: 24,
              iconWeight: selectedIndex == 0 ? CustomIconWeight.solid : CustomIconWeight.regular,
              color: selectedIndex == 0 ? primaryColor : secondaryColor,
            ),
            label: getTranslated(context, AppKeys.home),
          ),
          BottomNavigationBarItem(
            icon: IconComponent(
              iconData: CustomIconData.rectangleHistory,
              size: 24,
              iconWeight: selectedIndex == 1 ? CustomIconWeight.solid : CustomIconWeight.regular,
              color: selectedIndex == 1 ? primaryColor : secondaryColor,
            ),
            label: getTranslated(context, AppKeys.projects),
          ),
          BottomNavigationBarItem(
            // icon: IconComponent(
            //   iconData: CustomIconData.user,
            //   size: 24,
            //   iconWeight: selectedIndex == 2 ? CustomIconWeight.solid : CustomIconWeight.regular,
            //   color: selectedIndex == 2 ? primaryColor : secondaryColor,
            // ),
            icon: SizedBox(
              width: 30,
              height: 30,
              child: CircularPhotoComponent(
                url: ref.watch(userProvider).userModel!.profilePhotoURL,
                hasBorder: selectedIndex == 2 ? true : false,
              ),
            ),
            label: getTranslated(context, AppKeys.profile),
          )
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedPageIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
