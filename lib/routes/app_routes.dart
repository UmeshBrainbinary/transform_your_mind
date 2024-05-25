
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/binding/forgot_binding.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/new_password_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/verification_screen.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/binding/login_binding.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_screen.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/binding/register_binding.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/binding/splash_binding.dart';
import 'package:transform_your_mind/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';

  static const String splashScreen = '/splash_screen';

  static const String registerScreen = '/register_screen';

  static const String successPopupScreen = '/success_popup_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String forgotScreen = '/forgotScreen';
  static const String verificationsScreen = '/verificationsScreen';
  static const String newPasswordScreen = '/newPasswordScreen';

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


    GetPage(
      transition: Transition.rightToLeft,
      name: registerScreen,
      page: () => RegisterScreen(),
      bindings: [
        RegisterBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: forgotScreen,
      page: () => ForgotPasswordScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: verificationsScreen,
      page: () => VerificationsScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: newPasswordScreen,
      page: () => NewPasswordScreen(),
      bindings: [
        ForgotBinding(),
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
