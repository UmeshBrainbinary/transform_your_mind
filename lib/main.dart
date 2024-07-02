import 'dart:io';

import 'package:alarm/alarm.dart';
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
import 'package:transform_your_mind/presentation/auth/login_screen/network_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/theme/theme_helper.dart';

import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.loadTranslations();

  tz.initializeTimeZones();

  var detroit = tz.getLocation('Asia/Kolkata');
  tz.setLocalLocation(detroit);
  ConnectivityService().initialize();



  await PrefService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
/*
  await AndroidAlarmManager.cancel(42);
*/

  await Alarm.init();


}

class MyApp extends StatefulWidget {
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
    print("isDarkTheme:- ${PrefService.getBool(PrefKey.isDarkTheme)}");
    themeController.isDarkMode.value = PrefService.getBool(PrefKey.isDarkTheme);
    setAlarm();
   /* themeController.isDarkMode.isTrue?
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ))  :*/ getLanguages();

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
    await NotificationService.initializeNotifications(context);

    await NotificationService.requestPermissions();
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
  void setAlarm() async {
/*    DateTime alarmTime = DateTime.now().add(const Duration(minutes: 1)); // Example: Set alarm after 1 minute
    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: alarmTime,
      assetAudioPath: 'assets/audio/audio.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,androidFullScreenIntent: true,
      fadeDuration: 3.0,
      notificationTitle: 'This is the title',
      notificationBody: 'This is the body',
      enableNotificationOnKill: Platform.isAndroid);
    await Alarm.set(alarmSettings: alarmSettings,);*/
  }

  getLanguages() {
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
    Get.put(NetworkController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeController.isDarkMode.value
          ? ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          dialogTheme: DialogTheme(backgroundColor: ColorConstant.textfieldFillColor),
          scaffoldBackgroundColor: ColorConstant.black,
          navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              iconTheme: WidgetStatePropertyAll(IconThemeData(
                color: Colors.white, // Icon color
              ),)
          ),
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: Colors.white, backgroundColor: Colors.orange,
          //     textStyle: TextStyle(fontSize: 16.0),
          //   ),
          // ),
          textTheme: TextTheme(
            displayLarge: TextStyle(color: ColorConstant.white),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorConstant.black)

      )
          : ThemeData(
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(backgroundColor: Colors.black),
              primaryColor: ColorConstant.backGround,
              visualDensity: VisualDensity.adaptivePlatformDensity),
      /*theme: themeController.isDarkMode.value
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,*/
      translations: AppTranslations(),
      locale: newLocale,
      fallbackLocale: newLocale,
      title: 'Transform Your Mind',
      initialBinding: InitialBindings(),
      initialRoute:  AppRoutes.splashScreen,
/*      initialRoute: PrefService.getBool(PrefKey.isLoginOrRegister) == true
        ? AppRoutes.splashScreen
        : AppRoutes.splashScreen,*/
      //AppRoutes.initialRoute
      getPages: AppRoutes.pages,
    );
  }
}
