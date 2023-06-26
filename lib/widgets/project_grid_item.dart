import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/task_model.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class ProjectGridItem extends StatefulWidget {
  final ProjectModel projectModel;
  final Function()? onTap;
  final Color? containerColor;
  final Color? indicatorForegroundColor;
  final Color? indicatorBackgroundColor;

  const ProjectGridItem({
    super.key,
    required this.projectModel,
    this.onTap,
    this.containerColor = itemBackgroundLightColor,
    this.indicatorBackgroundColor = secondaryColor,
    this.indicatorForegroundColor = primaryColor,
  });

  @override
  State<ProjectGridItem> createState() => _ProjectGridItemState();
}

class _ProjectGridItemState extends State<ProjectGridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.containerColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MarqueeWidget(
              child: TextComponent(
                text: widget.projectModel.name,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: UIHelper.getDeviceWidth(context) / 4.5,
                    width: UIHelper.getDeviceWidth(context) / 4.5,
                    child: CircularProgressIndicator(
                      color: widget.indicatorForegroundColor,
                      strokeWidth: 15,
                      backgroundColor: widget.indicatorBackgroundColor,
                      value: widget.projectModel.tasks.isNotEmpty
                          ? (widget.projectModel.tasks.where((task) => task.situation == TaskSituation.done).length / widget.projectModel.tasks.length)
                              .toDouble()
                          : 0,
                    ),
                  ),
                  TextComponent(
                    text:
                        "${widget.projectModel.tasks.isNotEmpty ? (widget.projectModel.tasks.where((task) => task.situation == TaskSituation.done).length / widget.projectModel.tasks.length * 100).toStringAsFixed(0) : 0}%",
                    headerType: HeaderType.h6,
                  )
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
