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
import 'localization/app_localization.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.loadTranslations(); // Ensure translations are loaded

  await PrefService.init();

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });

/// localization on tap
 //var locale = const Locale('es', 'ES');
 //Get.updateLocale(locale);
  
 var locale = const Locale('en', 'US');
 Get.updateLocale(locale);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // set the desired status bar color
    statusBarIconBrightness: Brightness.dark, // set the status bar icon color to light or dark
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.put(ThemeController(),permanent: true);
    themeController.isDarkMode.listen((isDarkMode) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Obx(
      () =>
       GetMaterialApp(
         debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(),
        // darkTheme: ThemeData.dark(),
        theme: themeController.isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme,
         translations: AppTranslations(),
         locale: Locale('en', 'US'),
         fallbackLocale: Locale('en', 'US'),
        title: 'Transform Your Mind',
        initialBinding: InitialBindings(),
        initialRoute: PrefService.getBool(PrefKey.isLoginOrRegister) == true ? AppRoutes.dashBoardScreen : AppRoutes.loginScreen, //AppRoutes.initialRoute
        getPages: AppRoutes.pages,


      ),
    ) ;
  }
}
