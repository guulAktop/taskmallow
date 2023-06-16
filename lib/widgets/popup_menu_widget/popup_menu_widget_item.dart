import 'package:flutter/animation.dart';
import 'package:taskmallow/components/icon_component.dart';

class PopupMenuWidgetItem {
  String title;
  Function function;
  String? subTitle;
  CustomIconData? prefixIcon;
  CustomIconData? suffixIcon;
  Color? color;

  PopupMenuWidgetItem({
    required this.title,
    required this.function,
    this.subTitle,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
  });
}
