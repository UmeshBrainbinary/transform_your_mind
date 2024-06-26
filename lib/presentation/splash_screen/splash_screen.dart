import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        PrefService.getBool(PrefKey.isLoginOrRegister) == true
            ? Get.offAllNamed(AppRoutes.dashBoardScreen)
            :Get.offAllNamed(AppRoutes.introScreen);
      } ,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Image.asset(
      "assets/images/intro_splash.png",
      fit: BoxFit.fill,
      height: Get.height,
      width: Get.width,
    ));
  }
}
