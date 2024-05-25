
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/binding/login_binding.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/binding/splash_binding.dart';
import 'package:transform_your_mind/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';

  static const String splashScreen = '/splash_screen';

  static const String addPhotosScreen = '/add_photos_screen';

  static const String successPopupScreen = '/success_popup_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [

    GetPage(
      transition: Transition.rightToLeft,
      name: splashScreen,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: loginScreen,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: initialRoute,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),

    // GetPage(
    //   transition: Transition.rightToLeft,
    //   name: initialRoute,
    //   page: () => SplashScreen(),
    //   bindings: [
    //     SplashBinding(),
    //   ],
    // )

  ];
}
