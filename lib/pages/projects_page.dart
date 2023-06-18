import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../components/text_component.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  bool isLoading = false;
  double progressValue = 0.7;
  int projectsInvolvedCounter = 3;
  int completedTaskCounter = 27;
  static const projectCreater = "taskmallow";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseScaffoldWidget(
          title: "Projects",
          widgetList: [
            projectWidget(),
          ],
        ),
        floatingActionButton: buildFloatingButton(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, createProjectPageRoute),
      backgroundColor: primaryColor,
      child: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(
              iconData: CustomIconData.plus,
              color: shimmerLightHighlightColor,
              size: 100),
          onPressed: () =>
              Navigator.pushNamed(context, createProjectPageRoute)),
    );
  }

  Widget projectWidget() {
    return Column(
      children: const [
        ProjectContainer(
          title: 'Taskmallow',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.7,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
        ProjectContainer(
          title: 'App Jam',
          description: 'The error youre encountering suggests...',
          createdBy: projectCreater,
          progressValue: 0.4,
        ),
      ],
    );
  }
}

// PROJECT CONTAINER
class ProjectContainer extends StatelessWidget {
  final String title;
  final String description;
  final String createdBy;
  final double progressValue;

  const ProjectContainer({
    super.key,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: itemBackgroundLightColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextComponent(
                text: title,
                headerType: HeaderType.h5,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              TextComponent(
                textAlign: TextAlign.start,
                text: description,
                headerType: HeaderType.h6,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const TextComponent(
                    text: 'created by ',
                    headerType: HeaderType.h7,
                  ),
                  TextComponent(
                    text: createdBy,
                    headerType: HeaderType.h7,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 7,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextComponent(
                      text: '%${(progressValue * 100).toInt()}',
                      headerType: HeaderType.h6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
