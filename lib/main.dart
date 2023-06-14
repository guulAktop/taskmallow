import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/shared_preferences_constants.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/localization/language_localization.dart';
import 'package:taskmallow/pages/onboarding_pages/onboarding_page.dart';
import 'package:taskmallow/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper(WidgetsBinding.instance.window.locale).getSettingsSharedPreferencesValues();
    debugPrint(SharedPreferencesConstants.appLanguageCode);
  }

  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      debugPrint("locale : $locale");
    });
  }

  @override
  void didChangeDependencies() {
    SharedPreferencesHelper(WidgetsBinding.instance.window.locale).getSettingsSharedPreferencesValues();
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
        debugPrint(locale.languageCode.toString());
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale("en", "US"),
        Locale("tr", "TR"),
      ],
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      title: 'Taskmallow',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: primaryMaterialColor,
      ),
      home: const OnBoardingPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
