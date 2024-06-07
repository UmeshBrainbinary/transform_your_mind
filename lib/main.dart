import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/localization/app_translation.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/theme/theme_helper.dart';

import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.loadTranslations(); // Ensure translations are loaded

  await PrefService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });

  /// localization on tap
  //var locale = const Locale('de', 'De');
  //Get.updateLocale(locale);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // set the desired status bar color
    statusBarIconBrightness:
        Brightness.dark, // set the status bar icon color to light or dark
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeController themeController;
  String currentLanguage = PrefService.getString(PrefKey.language);
  Locale? newLocale;
  @override
  void initState() {
    super.initState();
    themeController = Get.put(ThemeController(), permanent: true);
    print("isDarkTheme:- ${PrefService.getBool(PrefKey.isDarkTheme)}");
    themeController.isDarkMode.value = PrefService.getBool(PrefKey.isDarkTheme);
    getLanguages();
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),

      theme: themeController.isDarkMode.value
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,

      translations: AppTranslations(),
      locale: newLocale,
      fallbackLocale: newLocale,
      title: 'Transform Your Mind',
      initialBinding: InitialBindings(),
      initialRoute: PrefService.getBool(PrefKey.isLoginOrRegister) == true
          ? AppRoutes.dashBoardScreen
          : AppRoutes.loginScreen,
      //AppRoutes.initialRoute
      getPages: AppRoutes.pages,
    );
  }
}
