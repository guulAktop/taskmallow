import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String title;
  const PrivacyPolicyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    String privacyPolicy = AppConstants.privacyPolicyEN;
    Locale locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case "en":
        privacyPolicy = AppConstants.privacyPolicyEN;
        break;
      case "tr":
        privacyPolicy = AppConstants.privacyPolicyTR;
        break;
      default:
        privacyPolicy = AppConstants.privacyPolicyEN;
    }
    return BaseScaffoldWidget(
      title: title,
      widgetList: [
        TextComponent(
          text: privacyPolicy,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
