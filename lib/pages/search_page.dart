import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

import '../components/icon_component.dart';
import '../constants/app_constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  bool _userFound = true;
  bool _projectFound = true;

  List<String> users = [
    "Firstname Lastname",
    "John Doe",
    "Jane Smith",
  ];

  List<String> projects = [
    "Bootcamp/Taskmallow",
    "Project XYZ",
    "Project ABC",
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      _searchText = _searchController.text;
      _userFound = users.any(
          (user) => user.toLowerCase().contains(_searchText.toLowerCase()));
      _projectFound = projects.any((project) =>
          project.toLowerCase().contains(_searchText.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: "Search",
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      widgetList: [
        Container(
          decoration: BoxDecoration(
            color: itemBackgroundLightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users or projects',
              prefixIcon: IconComponent(
                iconData: CustomIconData.magnifyingGlass,
                color: Colors.blue,
                size: 10.5,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 3),
            child: TextComponent(
              text: "Users",
              headerType: HeaderType.h6,
              color: textPrimaryLightColor,
            ),
          ),
        ),
        SizedBox(height: 6),
        _userFound
            ? Column(
                children: users
                    .where((user) =>
                        user.toLowerCase().contains(_searchText.toLowerCase()))
                    .map((user) => Column(
                          children: [
                            _buildUserContainer(user),
                            SizedBox(height: 6),
                          ],
                        ))
                    .toList(),
              )
            : Text(
                "User not found",
                style: TextStyle(color: danger),
              ),
        SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 3),
            child: TextComponent(
              text: "Projects",
              headerType: HeaderType.h6,
              color: textPrimaryLightColor,
            ),
          ),
        ),
        _projectFound
            ? Column(
                children: projects
                    .where((project) => project
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))
                    .map((project) => Column(
                          children: [
                            _buildProjectContainer(project),
                            SizedBox(height: 6),
                          ],
                        ))
                    .toList(),
              )
            : Text(
                "Project not found",
                style: TextStyle(color: danger),
              ),
      ],
    );
  }

  Widget _buildUserContainer(String user) {
    return Container(
      decoration: BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
        ),
        title: Text(user),
        subtitle: Text("example@gmail.com"),
      ),
    );
  }

  Widget _buildProjectContainer(String project) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            "Taskmallow is an innovative application that brings together project management and innovation. It is designed to manage your projects, track innovations, develop creative ideas, and find the most suitable tasks through matching feature.",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            "created by taskmallow",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.15, // %15
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                "%15",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
