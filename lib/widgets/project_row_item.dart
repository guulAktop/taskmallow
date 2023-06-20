import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/data_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/constants/task_situations_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class ProjectRowItem extends StatefulWidget {
  final ProjectModel project;
  final Function()? onTap;
  const ProjectRowItem({super.key, required this.project, this.onTap});

  @override
  State<ProjectRowItem> createState() => _ProjectRowItemState();
}

class _ProjectRowItemState extends State<ProjectRowItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextComponent(
              text: widget.project.name,
              headerType: HeaderType.h4,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            TextComponent(
              text: widget.project.description,
              textAlign: TextAlign.start,
              headerType: HeaderType.h6,
            ),
            const SizedBox(height: 10),
            MarqueeWidget(
              child: TextComponent(
                text:
                    "${(tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length * 100).toStringAsFixed(0)}% ${getTranslated(context, AppKeys.completed)}",
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
                softWrap: true,
                headerType: HeaderType.h7,
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: LinearProgressIndicator(
                minHeight: 20,
                value: (tasks.where((task) => task.situation == TaskSituation.done).length / tasks.length).toDouble(),
              ),
            ),
            const SizedBox(height: 10),
            TextComponent(
              text: widget.project.userWhoCreated.email,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.end,
              overflow: TextOverflow.fade,
              softWrap: true,
              headerType: HeaderType.h7,
            ),
          ],
        ),
      ),
    );
  }
}
