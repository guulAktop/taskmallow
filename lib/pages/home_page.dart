import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/localization/language.dart';
import 'package:taskmallow/localization/language_localization.dart';
import 'package:taskmallow/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Locale? _locale = const Locale("en");
  List<Language>? languages;

  void _changeLanguage(Language language) async {
    Locale locale = await setLocale(language.languageCode);

    if (mounted) {}
    MyApp.setLocale(context, locale);
  }

  @override
  void initState() {
    super.initState();
    languages = Language.languageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, AppKeys.homePage)),
        actions: [
          IconButton(
              onPressed: () {
                if (_locale?.languageCode == "en") {
                  _locale = const Locale("tr");
                } else {
                  _locale = const Locale("en");
                }
                setState(() {});
                _changeLanguage(languages!.firstWhere((element) => element.languageCode == _locale!.languageCode));
              },
              icon: const IconComponent(iconData: CustomIconData.earthAmericas))
        ],
      ),
      body: Column(),
    );
  }
}
