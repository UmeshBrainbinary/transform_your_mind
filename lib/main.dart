import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:transform_your_mind/core/service/notification_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/localization/app_translation.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';

bool? isSubscribed = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.loadTranslations();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDmL_3cUGmr0-sqqFSFyQQezS2x21z7pso",
            appId: '1:163422335038:ios:bac98b95c225f792db216f',
            messagingSenderId: '163422335038',
            projectId: 'transform-your-mind-afbb7')
    );
  } else {
    try {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDqVV8VZFujz90zhumJKkUcoyqVY-B3QpI",
              appId: "1:163422335038:android:9a43e6df9e637300db216f",
              messagingSenderId: "163422335038",
              projectId: 'transform-your-mind-afbb7'));
    }
    catch(E){

      print("=======");
    }
  }
  if(Platform.isIOS){
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

  }
  tz.initializeTimeZones();



  var detroit = tz.getLocation('Asia/Kolkata');
  tz.setLocalLocation(detroit);
  await PrefService.init();
  await NotificationService.init();
  String token  =  await NotificationService.generateFCMAccessToken();
  if (kDebugMode) {
    print(token);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(const MyApp());
  });

  await Alarm.init();
/*  if (Platform.isIOS) {
    StoreConfig(
      store: config.Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    StoreConfig(
      store: config.Store.googlePlay,
      apiKey: googleApiKey,
    );
  }*/
  if(Platform.isIOS){
    final fcmAPNSToken = await FirebaseMessaging.instance.getAPNSToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("fcmToken $fcmToken");
    debugPrint("apnsToken $fcmAPNSToken");

  }else{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("fcmTokenAndroid $fcmToken");

  }

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   ThemeController themeController = Get.put(ThemeController());
  String currentLanguage = PrefService.getString(PrefKey.language);
  Locale? newLocale;

  @override
  void initState() {
    super.initState();


    if(Platform.isIOS){
      requestIOSPermissions();
    }else{
      _initializeNotificationService();
    }
    themeController = Get.put(ThemeController(), permanent: true);
    debugPrint("isDarkTheme:- ${PrefService.getBool(PrefKey.isDarkTheme)}");
    themeController.isDarkMode.value = PrefService.getBool(PrefKey.isDarkTheme);

    getLanguages();

    if (themeController.isDarkMode.isTrue) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Future<void> _initializeNotificationService() async {
    await NotificationService.init();
    await NotificationService.generateFCMAccessToken();
/*await NotificationService.requestPermissions();*/
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  getLanguages() {
    print("c" +currentLanguage);
    if (currentLanguage.isNotEmpty) {
      if (currentLanguage == 'en-US') {
        newLocale = const Locale('en', 'US');
        Get.updateLocale(const Locale('en', 'US'));
      } else {
        newLocale = const Locale('de', 'DE');
        Get.updateLocale(const Locale('de', 'DE'));
      }
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeController.isDarkMode.value
          ? ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          dialogTheme: const DialogTheme(
              backgroundColor: ColorConstant.textfieldFillColor),
          scaffoldBackgroundColor: ColorConstant.black,
          navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              iconTheme: WidgetStatePropertyAll(IconThemeData(
                color: Colors.white, // Icon color
              ),)
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(color: ColorConstant.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: ColorConstant.black)

      )
          : ThemeData(
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(backgroundColor: Colors.black),
              primaryColor: ColorConstant.backGround,
              visualDensity: VisualDensity.adaptivePlatformDensity),
      translations: AppTranslations(),
      locale: newLocale,
      fallbackLocale: newLocale,
      title: 'Transform Your Mind',
      initialBinding: InitialBindings(),
      initialRoute:  AppRoutes.splashScreen,
      getPages: AppRoutes.pages,
    );
  }
}
