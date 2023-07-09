import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/localization/language.dart';
import 'package:taskmallow/localization/language_localization.dart';
import 'package:taskmallow/main.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/list_view_widget.dart';

class LanguageSettingsPage extends ConsumerStatefulWidget {
  final String title;
  const LanguageSettingsPage({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  Language? selectedLanguage;
  List<Language>? languages;

  @override
  void initState() {
    super.initState();
    languages = Language.languageList();
  }

  void _changeLanguage(Language language) async {
    Locale locale = await setLocale(language.languageCode);

    if (mounted) {
      MyApp.setLocale(context, locale);
    }
  }

  _setSelectedLang(Language lang) {
    setState(() {
      selectedLanguage = lang;
    });
  }

  Locale? _locale;
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (locale == null) {
        setState(() {
          _locale = View.of(context).platformDispatcher.locale;
          selectedLanguage = languages!.firstWhere((element) => element.languageCode == _locale!.languageCode);
        });
      } else {
        setState(() {
          _locale = locale;
          selectedLanguage = languages!.firstWhere((element) => element.languageCode == _locale!.languageCode);
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return BaseScaffoldWidget(title: widget.title, widgetList: [
      ListViewWidget(
        backgroundColor: listViewItemBackgroundLightColor,
        dividerColor: Colors.black.withOpacity(0.5),
        itemList: languages!.map((language) {
          return ListViewItem(
              onTap: () async {
                _setSelectedLang(selectedLanguage as Language);
                _changeLanguage(language);
                selectedLanguage = language;
                await userRepository.updateUserLocale(language.languageCode);
              },
              title: language.name,
              prefixWidget: Radio(
                activeColor: primaryColor,
                value: language,
                groupValue: selectedLanguage,
                onChanged: (selectedLanguage) async {
                  _setSelectedLang(selectedLanguage as Language);
                  _changeLanguage(selectedLanguage);
                  selectedLanguage = language;
                  await userRepository.updateUserLocale(language.languageCode);
                },
              ));
        }).toList(),
      ),
    ]);
  }
}
