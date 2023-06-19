import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/pages/navigation_pages/home_page.dart';
import 'package:taskmallow/pages/navigation_pages/projects_page.dart';
import 'package:taskmallow/pages/navigation_pages/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          HomePage(),
          ProjectsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: appBackgroundLightColor,
        selectedItemColor: primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconComponent(
              iconData: CustomIconData.house,
              size: 24,
              iconWeight: _selectedIndex == 0 ? CustomIconWeight.solid : CustomIconWeight.regular,
              color: _selectedIndex == 0 ? primaryColor : secondaryColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: IconComponent(
              iconData: CustomIconData.rectangleHistory,
              size: 24,
              iconWeight: _selectedIndex == 1 ? CustomIconWeight.solid : CustomIconWeight.regular,
              color: _selectedIndex == 1 ? primaryColor : secondaryColor,
            ),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: IconComponent(
              iconData: CustomIconData.user,
              size: 24,
              iconWeight: _selectedIndex == 2 ? CustomIconWeight.solid : CustomIconWeight.regular,
              color: _selectedIndex == 2 ? primaryColor : secondaryColor,
            ),
            label: "Profile",
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
