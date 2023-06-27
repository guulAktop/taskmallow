import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/firebase_options.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/localization/language_localization.dart';
import 'package:taskmallow/pages/indicator_page.dart';
import 'package:taskmallow/routes/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings =
      await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: false, criticalAlert: true, provisional: false, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("User granted permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint("User granted provisional permission");
  } else {
    debugPrint("User declined or has not accepted permission!");
  }
}

initInfo() {
  var androidInitialize = const AndroidInitializationSettings('@mipmap/launcher_icon');
  var iOSInitialize = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } catch (e) {
        debugPrint("initInfo Error: $e");
      }
      return;
    },
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "taskmallow",
      "taskmallow",
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const IOSNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifics,
        payload: message.data['body']);
  });
}

Locale? _locale;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.getInitialMessage();
  requestPermission();
  initInfo();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await getLocale().then((locale) {
    _locale = locale;
  });
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const riverpod.ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
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
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      debugPrint("locale : $locale");
    });
  }

  @override
  void didChangeDependencies() async {
    SharedPreferencesHelper(View.of(context).platformDispatcher.locale).getSettingsSharedPreferencesValues();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("LOCALE: $_locale");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      locale: _locale ?? View.of(context).platformDispatcher.locale,
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
      home: const IndicatorPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
