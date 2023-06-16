import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String title;
  const PrivacyPolicyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(title: title, widgetList: const [
      TextComponent(text: ""),
    ]);
  }
}
